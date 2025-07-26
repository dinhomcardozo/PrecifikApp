import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "icms", "ipi", "pisCofins"]

  connect() {
    this.selectTarget.addEventListener("change", this.updateFields.bind(this))
  }

  updateFields() {
    const tax = JSON.parse(this.selectTarget.selectedOptions[0].dataset.json || "{}")
    this.icmsTarget.value      = (tax.icms * 100).toFixed(2)
    this.ipiTarget.value       = (tax.ipi * 100).toFixed(2)
    this.pisCofinsTarget.value = (tax.pis_cofins * 100).toFixed(2)
  }
}