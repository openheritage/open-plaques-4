// app/javascript/controllers/mobile_menu_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    // Toggle mobile nav dropdowns
    document.querySelectorAll('.navmenu .toggle-dropdown').forEach(navmenu => {
      navmenu.addEventListener('click', function (e) {
        e.preventDefault()
        this.parentNode.classList.toggle('active')
        this.parentNode.nextElementSibling.classList.toggle('dropdown-active')
        e.stopImmediatePropagation()
      })
    })
  }

  toggle(event) {
    const mobileNavToggleBtn = event.currentTarget
    document.querySelector('body').classList.toggle('mobile-nav-active')
    mobileNavToggleBtn.classList.toggle('bi-list')
    mobileNavToggleBtn.classList.toggle('bi-x')
  }
}
