// app/javascript/controllers/geojson_controller.js
import { Controller } from '@hotwired/stimulus'
import { useDelegate } from 'controllers/mixins/use_delegate'

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
    })
  }
}
