// app/javascript/controllers/maplibre_controller.js
import { Controller } from '@hotwired/stimulus'
import maplibregl from 'maplibre-gl'
// import Rails from '@rails/ujs'
import LayerSwitcher from 'layer-switcher'

export default class extends Controller {
  initialize() {
    this.__controls = {}
    if (this.defaultConfig) {
      var userDefaults = this.defaultConfig()
    } else {
      var userDefaults = {}
    }
    // values that include Rails variables need to be passed from the view
    // e.g. an ActiveRecord object's bounds
    // defaults are *overwritten* by any that are passed
    var defaultStyle = Object.assign({
      attributionControl: false,
      centroid: [0, 52.0],
      controls: {
        attribution: {},
        draw: { position: 'bottom-right' },
        fullscreen: true,
        geolocate: false,
        layerswitcher: true,
        scale: true
      },
      layers: {},
      sources: {},
      style: "https://api.maptiler.com/maps/bright/style.json?key=qSorA16cJhhBZEhqDisF",
      zoom: 15
    }, userDefaults)
    if (this.element.dataset.maplibreStyle) {
      var localStyle = JSON.parse(this.element.dataset.maplibreStyle)
      this.__style = Object.assign(defaultStyle, localStyle)
    } else {
      this.__style = defaultStyle
    }
    if (this.__style.style && this.getStyleUrl) {
      this.__style.style = this.getStyleUrl(this.__style.style)
    }
    this.context.logDebugActivity('initialize#overridden', this.__style)
    if (this.element.dataset.project) {
      this.__project = JSON.parse(this.element.dataset.project)
    }
  }

  connect() {    
    var style = this.__style
    if (style.accessToken) {
      maplibregl.accessToken = style.accessToken
    }
    this.__map = new maplibregl.Map(Object.assign(style, {
      center: style.centroid,
      container: this.element,
      zoom: style.zoom
    }))
    this.__addControl('attribution')
    this.__addControl('draw')
    this.__addControl('fullscreen')
    this.__addControl('geolocate')
    this.__addControl('layerswitcher')
    this.__addControl('navigation')
    this.__addControl('scale')
    this.__map.on('load', () => {
      this.__onMapLoaded()
    })
    this.__map.on('draw.create', function (e) {
      var geojson_setter = document.getElementById('project_geojson_setter')
      if (geojson_setter !== null && typeof(geojson_setter) != 'undefined' && e.features[0].geometry.type !== 'LineString') {
        console.log(JSON.stringify(e.features[0]))
        geojson_setter.value = JSON.stringify(e.features[0])
        Rails.fire(geojson_setter, 'change')
        e.target._controls.forEach(control => {
          if (control.hasOwnProperty('mapMeasureDrawTool')) {
            control.mapMeasureDrawTool.deleteAll()
          }
        })
      }
    })
  }

  disconnect() {
    this.__map.remove()
    this.__map = undefined
    if (this.onDisconnect) { this.onMapUnloaded() }
  }

  __addControl(control) {
    this.context.logDebugActivity(`__addControl('${control}')`)
    if (this.__style.controls[control]) {
      var klass = null
      switch (control) {
        case 'attribution':
          klass = maplibregl.AttributionControl
          break
        //case 'draw':
        //  klass = MapMeasureTool
        //  break  
        case 'fullscreen':
          klass = maplibregl.FullscreenControl
          break
        case 'geolocate':
          klass = maplibregl.GeolocateControl
          break
        case 'layerswitcher':
          klass = LayerSwitcher
          break
        case 'navigation':
          klass = maplibregl.NavigationControl
          break
        case 'scale':
          klass = maplibregl.ScaleControl
          break
        default:
          null
      }
      if (klass) {
        var options = this.__style.controls[control]
        var ctrl = this.__controls[control] = new klass(options)
        this.__map.addControl(ctrl, options.position)
      }
    }
  }

  addSource(id, values) {
    const map = this.__map
    const source = map.getSource(id)
    if (source) {
      this.context.logDebugActivity(`updateSource(${values.type}:${id}, ${values})`, values)
      if (values.type === 'geojson') {
        source.setData(values.data)
      } else {
        // throw new Error(`not sure how to update a source type ${values.type}`)
      }
    } else {
      this.context.logDebugActivity(`addSource(${values.type}:${id}, ${values})`, values)
      map.addSource(id, values)
    }
  }

  addLayer(id, values) {
    this.context.logDebugActivity(`addLayer(${id})`)
    const map = this.__map
    if (map.getLayer(id)) {
      this.context.logDebugActivity(`layer ${id} already exists....updating it`)
      Object.keys(values.paint).forEach((k) => {
        this.context.logDebugActivity(`${id} ${k} ${values.paint[k]}`)
        map.setPaintProperty(id, k, values.paint[k])
      })
    } else {
      map.addLayer(Object.assign(values, {id: id}), this.__lastSymbolLayer())
    }
    var layerSwitcher = this.__controls['layerswitcher']
    layerSwitcher.menuItem(id)
  }

  applyStyle(style) {
    this.context.logDebugActivity(`applyStyle`, style)
    if (style.sources) {
      Object.keys(style.sources).forEach((id) => {
        this.addSource(id, style.sources[id])
      })
    }
    if (style.layers) {
      Object.keys(style.layers).forEach((id) => {
        this.addLayer(id, style.layers[id])
      })
    }
  }

  __lastSymbolLayer() {
    var layers = this.__map.getStyle().layers;
    var labelLayerId
    for (var i = 0; i < layers.length; i++) {
      if (layers[i].type === 'symbol' && layers[i].layout['text-field']) {
        labelLayerId = layers[i].id;
        break
      }
    }
    this.context.logDebugActivity(`__lastSymbolLayer is '${labelLayerId}'`)
    return labelLayerId
  }

  showBuildings() {
    const map = this.__map
    map.setPaintProperty('buildings', 'fill-extrusion-opacity', [
      'interpolate',
      ['exponential', 0.5],
      ['zoom'],
      // When zoom is 15, buildings will be solid.
      15,
      1,
      // When zoom is 18 or higher, buildings will be slighty see-through.
      18,
      0.5
    ])
    // map._controls.find(ele => ele instanceof LayerSwitcher).menuItem('buildings')
  }

  shrinkBuildings() {
    const map = this.__map
  }

  remove(layer_name) {
    this.context.logDebugActivity(`remove(${layer_name})`)
    const map = this.__map
    if (map.getLayer(layer_name)) { map.removeLayer(layer_name) }
  }

  removeMoveableSiteMarker() {
    const map = this.__map
    map._markers.forEach(m => m.remove())
    if (typeof marker !== 'undefined') {
      marker = undefined
    }
  }

  __onMapLoaded() {
    var style = this.__style
    this.context.logDebugActivity(`__onMapLoaded`)
    const map = this.__map
    map.loadImage(
      'https://docs.mapbox.com/mapbox-gl-js/assets/custom_marker.png',
      function (error, image) {
        if (error) throw error;
        if (!map.hasImage('site-marker')) {
          map.addImage('site-marker', image)
        }
      }
    )
    Object.keys(style.sources || {}).forEach((id) => {
      this.context.logDebugActivity(`adding source ${id}`, style.sources[id])
      this.addSource(id, style.sources[id])
    })
    Object.keys(style.layers || {}).forEach((id) => {
      this.context.logDebugActivity(`adding layer ${id}`, style.layers[id])
      this.addLayer(id, style.layers[id])
    })
    Object.keys(style.vector_tiles || {}).forEach((id) => {
      this.__vector_layer(id, style.vector_tiles[id])
    })
    // map.setTerrain({ source: 'maplibre-dem', exaggeration: 3.0 })
    // this.showBuildings()

    if (this.onMapLoaded) {
      this.onMapLoaded(map)
    }
    // wait until map is ready before making available to other controllers as a delegate
    this.__attach_controller()
  }

  __vector_layer(id, config) {
    const map = this.__map
    const url = `https://s3.eu-west-1.amazonaws.com/tiles.tapirtech.co.uk/${id}/metadata_https.json`
    const layer_default = {
      id: id,
      source: `${id}_source`,
      'source-layer': id,
      type: 'fill',
      paint: {
        'fill-color': '#ec7211',
        'fill-opacity': 0.5
      }
    }
    const overridden_defaults = Object.assign(layer_default, config)
    this.context.logDebugActivity(`__vector_layer('${id}', config)`, { config: overridden_defaults, tiles_metadata_url: url })
    // this could be another layer from an already declared source
    if (!map.getSource(overridden_defaults['source'])) {
      map.addSource(overridden_defaults['source'], { maxzoom: 14, minzoom: 10, type: 'vector', url: url })
    }
    map.addLayer(overridden_defaults, 'Water names')
  }

  __attach_controller() {
    this.context.logDebugActivity(`__attach_controller`)
    this.element['controller'] = this
    const n = document.createElement('div')
    n.setAttribute('id', 'controller')
    this.element.appendChild(n)
  }

  __raster_layer(layer) {
    this.context.logDebugActivity(`__raster_layer('${layer}')`)
    const map = this.__map
    map.addSource(`app-${layer}-source`, {
      type: 'raster',
      tiles: [`/geodata/${layer}?blibre={blibre-epsg-3857}`],
      tileSize: 256
    })
    map.addLayer({
        id: `app-${layer}`,
        type: 'raster',
        source: `app-${layer}-source`,
        layout: {
          visibility: 'none'
        },
        paint: {
          'raster-opacity': 0.7
        }
      }, this.__lastSymbolLayer()
    )
  }

  fitBounds(bounds_param, buffer=0.001) {
    let bounds = [0, 0, 0, 0]
    if (Array.isArray(bounds_param)) {
      bounds = bounds_param
    } else {
      bounds = JSON.parse(bounds_param)
    }
    bounds = [bounds[0] - buffer, bounds[1] - buffer, bounds[2] + buffer, bounds[3] + buffer]
    this.context.logDebugActivity(`fitBounds`, bounds)
    this.__map.fitBounds(bounds)
  }

  flyToCoord(centroid_param, zoom) {
    this.context.logDebugActivity(`flyToCoord('${centroid_param}', ${zoom})`)
    this.__map.flyTo({ center: JSON.parse(centroid_param), zoom: zoom })
  }

  reload() {
    const map = this.__map
    const fs = this.__map.getSource(farm_source)
    if (fs) {
      this.context.logDebugActivity(`reload`)
      fs.setData(fs._data)
      function onSourceData (e) {
        if (e.isSourceLoaded) {
          // the update is complete: unsubscribe this listener
          map.off('sourcedata', onSourceData)
          map.removeFeatureState({ source: farm_source })
        }
      }
      map.on('sourcedata', onSourceData)
    }
  }

  toggleLayer(name) {
    this.context.logDebugActivity(`toggleLayer('${name}')`)
    const map = this.__map
    const layer = map.getLayer(`app-${name}`) || map.getLayer(name)
    if (layer) {
      var visibility = map.getLayoutProperty(layer.id, 'visibility')
      if (visibility === undefined || visibility === 'visible') {
        map.setLayoutProperty(layer.id, 'visibility', 'none')
      } else {
        map.setLayoutProperty(layer.id, 'visibility', 'visible')
      }
    }
  }
   
  // resetting the style will remove our sources and layers
  // layers and sources have been prefixed with 'app-'
  // so they can be remembered and reapplied
  setStyle(name) {
    this.context.logDebugActivity(`setStyle('${name}')`)
    const map = this.__map
    function forEachLayer(text, cb) {
      map.getStyle().layers.forEach((layer) => {
        if (!layer.id.startsWith(text)) return
    
        cb(layer)
      })
    }
    const layers = []
    const sources = {}
    forEachLayer('app-', (layer) => {
      sources[layer.source] = map.getSource(layer.source).serialize()
      layers.push(layer)
    })
    map.setStyle(name)
    setTimeout(() => {
      Object.entries(sources).forEach(([id, source]) => {
        map.addSource(id, source)
      })
      layers.forEach((layer) => {
        map.addLayer(layer, this.__lastSymbolLayer())
      })
    }, 1000)
    // lock this toggle to on
    // turn all the other style toggles off
    const buttons = document.getElementsByClassName('style-switch')
    for (var i = 0; i < buttons.length; i++) {
      const input = buttons.item(i).getElementsByClassName('form-check-input')[0]
      input.checked = input.getAttribute('data-layer') === name
    }
  }
}
