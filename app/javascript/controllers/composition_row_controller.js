import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values  = { costPerGram: Number }
  static targets = [ "cost" ]

  connect() {
    this.calculate()
  }

  updateCostPerGram(e) {
    const opt = e.currentTarget.selectedOptions[0]
    this.costPerGramValue = parseFloat(opt.dataset.costPerGram) || 0
    this.calculate()
  }

  calculate() {
    const qtyField = this.element.querySelector("input[name*='[quantity]']")
    const qty      = parseFloat(qtyField.value) || 0
    const cost     = (qty * this.costPerGramValue).toFixed(2)

    this.costTarget.value = cost
  }

  removeRow(e) {
    e.preventDefault()
    const destroyInput = this.element.querySelector("input[name*='[_destroy]']")
    if (this.element.dataset.newRecord === "true") {
      this.element.remove()
    } else if (destroyInput) {
      destroyInput.value = 1
      this.element.style.display = "none"
    }
  }
}