// app/javascript/controllers/swiper_controller.js
import { Controller } from "@hotwired/stimulus"
import Swiper from "https://cdn.jsdelivr.net/npm/swiper@12/swiper-bundle.min.mjs"
// import Swiper from "swiper"

export default class extends Controller {
  static targets = [ "container", "next", "prev", "pagination" ]

  connect() {
    this.containerTarget.className = "swiper"
    this.nextTarget.className = "swiper-button-next"
    this.prevTarget.className = "swiper-button-prev"
    this.paginationTarget.className = "swiper-pagination"

    this.swiper = new Swiper(this.containerTarget, {
      loop: true,
      navigation: {
        nextEl: this.nextTarget,
        prevEl: this.prevTarget
      },
      pagination: {
        el: this.paginationTarget,
        type: "bullets",
        clickable: true
      }
    })
  }
}
