import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const select = this.element.querySelector("select option:checked")
    if (select && select.value) {
      this.updateCostFromSelect()
    }
  }

  // Atualiza custo base quando troca o select
  updateCostFromSelect() {
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
    this.unit         = unit
    this.cost         = parseFloat(opt.dataset.cost)   || 0
    this.weightPer    = parseFloat(opt.dataset.weight) || 0
  }

  calculate() {
    const row = this.element
    const select = row.querySelector("select option:checked")
    if (!select) return

    const unit = select.dataset.unit
    const costPerUnit = parseFloat(select.dataset.cost)   || 0
    const weightPer   = parseFloat(select.dataset.weight) || 0

    const weightField       = row.querySelector("input[name*='[weight]']")
    const requireUnitsField = row.querySelector("input[name*='[require_units]']")
    const costField         = row.querySelector("input[name*='[cost]']")

    if ((unit === "g" || unit === "ml") && weightField) {
      const weight = parseFloat(weightField.value) || 0
      if (weight > 0 && weightPer > 0) {
        const requireUnits = weight / weightPer
        const totalCost    = requireUnits * costPerUnit
        if (requireUnitsField) requireUnitsField.value = requireUnits.toFixed(2)
        if (costField)         costField.value         = totalCost.toFixed(2)
      } else {
        if (requireUnitsField) requireUnitsField.value = ""
        if (costField)         costField.value         = ""
      }
    }

    if (unit === "un" && requireUnitsField) {
      const requireUnits = parseFloat(requireUnitsField.value) || 0
      if (requireUnits > 0) {
        const weight    = requireUnits * weightPer
        const totalCost = requireUnits * costPerUnit
        if (weightField) weightField.value = weight.toFixed(2)
        if (costField)   costField.value   = totalCost.toFixed(2)
      } else {
        if (weightField) weightField.value = ""
        if (costField)   costField.value   = ""
      }
    }

    if (unit === "m2" && requireUnitsField) {
      const requireUnits = parseFloat(requireUnitsField.value) || 0
      if (requireUnits > 0) {
        const weight    = requireUnits * weightPer
        const totalCost = requireUnits * costPerUnit
        if (weightField) weightField.value = weight.toFixed(2)
        if (costField)   costField.value   = totalCost.toFixed(2)
      } else {
        if (weightField) weightField.value = ""
        if (costField)   costField.value   = ""
      }
    }

    row.dispatchEvent(new CustomEvent("row:updated", { bubbles: true }))
  }

  removeRow(event) {
    event.preventDefault()
    const block = this.element
    const destroyInput = block.querySelector("input[name*='[_destroy]']")
    if (block.dataset.newRecord === "true") {
      block.remove()
    } else if (destroyInput) {
      destroyInput.value = 1
      block.style.display = "none"
    }
    block.dispatchEvent(new CustomEvent("row:updated", { bubbles: true }))
  }
}