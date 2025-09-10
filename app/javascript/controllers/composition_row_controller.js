import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values  = { costPerGram: Number }
  static targets = ["quantity", "cost", "costValue"]


  connect() {
    const selected = this.element.querySelector("select[name*='[subproduct_id]'] option:checked")
    this.costPerGramValue = parseFloat(selected?.dataset.costPerGram) || 0

    if (this.hasQuantityTarget && this.hasCostTarget) {
      this.calculate()
    }
  }

  updateCostPerGram(e) {
    this.costPerGramValue = parseFloat(
      e.target.selectedOptions[0].dataset.costPerGram
    ) || 0
    console.log("► nova costPerGram:", this.costPerGramValue)
    this.calculate()
  }

  calculate() {
    const qty = parseFloat(this.quantityTarget.value) || 0
    const costPerGram = this.costPerGramValue || 0
    const c = (qty * costPerGram).toFixed(2)

    this.costTarget.value = c
    if (this.hasCostValueTarget) {
      this.costValueTarget.value = c
    }

    this.element.dispatchEvent(new CustomEvent("row:updated", { bubbles: true }))
  }

  removeRow(event) {
    event.preventDefault()
    const destroyInput = this.element.querySelector("input[name*='[_destroy]']")
    if (this.element.dataset.newRecord === "true") {
      this.element.remove()
    } else if (destroyInput) {
      destroyInput.value = 1
      this.element.style.display = "none"
    }
  }
}