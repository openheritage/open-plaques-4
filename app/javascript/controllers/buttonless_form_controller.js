// app/javascript/controllers/buttonless_form_controller.js
import { Controller } from '@hotwired/stimulus'
import debounce from 'lodash.debounce'

export default class extends Controller {
  connect() {
    let that = this;
    that.element.addEventListener('change', debounce(that.handleChange, 500))
  }

  handleChange(event) {
    event.preventDefault()
    console.log(`hits submit for you...`)
    event.target.form.requestSubmit()
  }
}
