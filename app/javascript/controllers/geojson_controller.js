// app/javascript/controllers/geojson_controller.js
import { Controller } from '@hotwired/stimulus'
import { useDelegate } from 'controllers/mixins/use_delegate'
import * as maplibregl from 'maplibre-gl'

export default class extends Controller {
  connect() {
    this.context.logDebugActivity('connect')
    useDelegate(this)
    this.__map_id = this.element.dataset.mapId
    this.__url = this.element.dataset.url
    this.add()
    this.element.remove()
  }

  add() {
    this.waitForController(this.__map_id).then ((delegate) => {
      this.context.logDebugActivity(`add(${this.__url})`, this.__url)
      const map = delegate.__map
      map.addSource('geojson_src', { type: 'geojson', data: this.__url })
      map.addLayer({ id: 'geojson_layer', source: 'geojson_src', type: 'circle', 'paint': { 'circle-color':  '#1511ecff', 'circle-radius': 5}})
      map.on('click', 'geojson_layer', (e) => {
        // Grab the first intersecting feature
        const feature = e.features[0]
        this.context.logDebugActivity(feature.properties)

        // Extract properties from GeoJSON
        const plaque = feature.properties
        const description = '<div class="inscription">' + this.__truncate(plaque.inscription, 255) + '</div><div class="info">' +
                    '<a class="link" href="/plaques/' + plaque.id + '">Plaque ' + plaque.id + '</a>'
    
        // Create and add the popup
        new maplibregl.Popup()
            .setLngLat(e.lngLat)
            .setHTML(`${description}`)
            .addTo(map)
      })
      
      // Change cursor to pointer when hovering over the layer
      map.on('mouseenter', 'geojson_layer', () => {
          map.getCanvas().style.cursor = 'pointer'
      })
      map.on('mouseleave', 'geojson_layer', () => {
          map.getCanvas().style.cursor = ''
      })
    })
  }

  __truncate(string, max_length) {
    if (string.length > max_length) {
      return string.substring(0, max_length) + '...';
    } else {
      return string;
    }
  }
}
