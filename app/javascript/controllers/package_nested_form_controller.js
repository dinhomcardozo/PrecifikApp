// app/javascript/controllers/package_nested_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values  = { templateId: String }

  addField(event) {
    event.preventDefault()

    const template = document.getElementById(this.templateIdValue)
    const newId    = new Date().getTime()
    const content  = template.innerHTML.replace(/NEW_RECORD/g, newId)

    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  removeField(event) {
    event.preventDefault()
    const row = event.target.closest("tr")
    if (!row) return

    const destroyInput = row.querySelector('input[name*="_destroy"]')
    if (destroyInput) destroyInput.value = '1'

    row.style.display = 'none'
  }
}