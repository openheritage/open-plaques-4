import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // remove the element tagged as a preloader
    this.element.remove()
  }
}
