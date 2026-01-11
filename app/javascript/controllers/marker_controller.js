// app/javascript/controllers/marker_controller.js
import { Controller } from '@hotwired/stimulus'
import { useDelegate } from 'controllers/mixins/use_delegate'
import maplibregl from 'maplibre-gl'

export default class extends Controller {
  connect() {
    this.context.logDebugActivity('connect')
    useDelegate(this)
    this.__map_id = this.element.dataset.mapId
    this.__center_point_array = JSON.parse(this.element.dataset.centerPointArray)
    this.add()
    this.element.remove()
  }

  add() {
    this.waitForController(this.__map_id).then ((delegate) => {
      this.context.logDebugActivity(`add(${this.__center_point_array})`, this.__center_point_array)
      const map = delegate.__map
      const marker = document.createElement('div')
      marker.className = 'site-marker'
      new maplibregl.Marker(marker).setLngLat(this.__center_point_array).addTo(map)
    })
  }
}
