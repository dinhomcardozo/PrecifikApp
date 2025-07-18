import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values  = { costPerGram: Number }
  static targets = ["quantity", "cost"]

  connect() {
    console.log("composition-row conectado:", this.costPerGramValue)
    this.calculate()
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
    const c   = (qty * this.costPerGramValue).toFixed(2)
    console.log("→ calculate:", qty, "×", this.costPerGramValue, "=", c)
    this.costTarget.value = c
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