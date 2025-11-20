// app/javascript/controllers/swiper_controller.js
import { Controller } from "@hotwired/stimulus"
import { Swiper } from "swiper"

export default class extends Controller {
  static targets = ["container", "next", "prev"]

  connect() {
    this.swiper = new Swiper(this.containerTarget, {
      navigation: {
        nextEl: this.nextTarget,
        prevEl: this.prevTarget,
      },
    })
  }
}
