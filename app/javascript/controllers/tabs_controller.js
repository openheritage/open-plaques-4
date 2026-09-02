// app/javascript/controllers/tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    this.show(this.tabTargets[0])
  }

  change(event) {
    event.preventDefault()
    this.show(event.currentTarget)
  }

  show(selectedTab) {
    const targetId = selectedTab.dataset.target

    this.tabTargets.forEach(tab => {
      tab.classList.toggle("active", tab === selectedTab)
    })

    this.panelTargets.forEach(panel => {
      panel.classList.toggle("show", panel.id === targetId)
      panel.classList.toggle("active", panel.id === targetId)
      panel.hidden = panel.id !== targetId
    })
  }
}
