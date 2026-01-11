// app/javascript/controllers/fitbounds_controller.js
// <template data-controller="fitbounds" data-bounds="[51.39813971416794, -0.8580715294924949, 51.40203883432606, -0.8513022931296153]"></template>
import { Controller } from "@hotwired/stimulus"
import { useDelegate } from "controllers/mixins/use_delegate"

export default class extends Controller {
  initialize() {
    useDelegate(this)
    const data = this.element.dataset
    this.__map_id = data.mapId
    const bounds = data.bounds
    if (bounds !== undefined) {
      this.waitForController(this.__map_id).then ((delegate) => {
        delegate.fitBounds(bounds)
        this.element.remove()
      })
    }
  }
}
