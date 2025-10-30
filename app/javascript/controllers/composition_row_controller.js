import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["quantity", "cost", "costValue"]

  connect() {
    this.updateCostFromSelect()
    if (this.hasQuantityTarget && this.hasCostTarget) {
      this.calculate()
    }
  }

  // Atualiza custo base quando troca o select
  updateCostFromSelect(e) {
    const row = this.element
    const type = row.dataset.type   // "subproduct" ou "input"
    const unit = row.dataset.unit   // "g", "ml", "un", "m2"

    let opt
    if (type === "subproduct") {
      opt = row.querySelector("select[name*='[subproduct_id]'] option:checked")
    } else if (type === "input") {
      opt = row.querySelector("select[name*='[input_id]'] option:checked")
    }

    if (!opt) return

    // guarda os custos disponíveis no dataset
    this.costPerGram  = parseFloat(opt.dataset.costPerGram)  || 0
    this.costPerUnit  = parseFloat(opt.dataset.costPerUnit)  || 0
    this.costPerM2    = parseFloat(opt.dataset.costPerM2)    || 0
    this.unit         = unit
  }

  calculate() {
    const qty = parseFloat(this.quantityTarget.value) || 0
    let cost = 0

    if (this.unit === "g" || this.unit === "ml") {
      cost = qty * this.costPerGram
    } else if (this.unit === "un") {
      cost = qty * this.costPerUnit
    } else if (this.unit === "m2") {
      cost = qty * this.costPerM2
    }

    const c = cost.toFixed(2)

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
    this.element.dispatchEvent(new CustomEvent("row:updated", { bubbles: true }))
  }
}