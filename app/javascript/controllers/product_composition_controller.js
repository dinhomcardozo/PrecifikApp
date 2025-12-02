import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list","weightLoss","grossWeight","finalWeight","finalizeButton"]

  connect() {
    this.element.addEventListener("row:updated", () => this.recalcWeights())
    this.refreshAll()
  }

  addSubproduct(e) {
    e.preventDefault()
    const tpl = document.getElementById("template-subproduct")
    if (!tpl) return
    const frag = tpl.content.cloneNode(true)
    const row = frag.querySelector("tr")
    if (!row) return
    row.innerHTML = row.innerHTML.replace(/NEW_RECORD/g, Date.now())
    this.listTarget.appendChild(row)
    this.refreshAll()
  }

  addInput(e) {
    e.preventDefault()
    const tpl = document.getElementById("template-input")
    if (!tpl) return
    const frag = tpl.content.cloneNode(true)
    const row = frag.querySelector("tr")
    if (!row) return
    row.innerHTML = row.innerHTML.replace(/NEW_RECORD/g, Date.now())
    this.listTarget.appendChild(row)
    this.refreshAll()
  }

  removeField(e) {
    e.preventDefault()
    const block = e.currentTarget.closest("tr[data-controller='composition-row']")
    if (!block) return
    const destroyInput = block.querySelector("input[name*='[_destroy]']")
    if (block.dataset.newRecord === "true") {
      block.remove()
    } else if (destroyInput) {
      destroyInput.value = 1
      block.style.display = "none"
    }
    this.refreshAll()
  }

  refreshAll() {
    this.listTarget
      .querySelectorAll("input[data-action*='composition-row#calculate']")
      .forEach(el => el.dispatchEvent(new Event("input", { bubbles: true })))
    this.recalcWeights()
    this.toggleFinalizeButton()
  }

  recalcWeights() {
    const weightEls = this.listTarget.querySelectorAll("input[name*='[weight]']")
    const gross = Array.from(weightEls).reduce((s, el) => s + (parseFloat(el.value) || 0), 0)
    const lossPct = parseFloat(this.weightLossTarget?.value) || 0
    const ratio   = Math.max(0, Math.min(100, 100 - lossPct)) / 100
    const finalW  = gross * ratio
    if (this.grossWeightTarget) this.grossWeightTarget.value = gross.toFixed(4)
    if (this.finalWeightTarget) this.finalWeightTarget.value = finalW.toFixed(4)
    const costEls = this.listTarget.querySelectorAll("input[name*='[cost]']")
    const totalCost = Array.from(costEls).reduce((s, el) => s + (parseFloat(el.value) || 0), 0)
    const totalCostField = this.element.querySelector("input[name*='[total_cost]']")
    if (totalCostField) totalCostField.value = totalCost.toFixed(2)
  }

  updateHeader(unit) {
    const thead = this.element.querySelector("thead tr")
    const headWrapper = this.element.querySelector("thead")
    if (!thead || !headWrapper) return
    headWrapper.classList.add("simple-head")
    unit = unit?.trim().toLowerCase()
    if (unit === "g" || unit === "ml") {
      thead.innerHTML = `
        <th>Item</th>
        <th>Peso (g/mL)</th>
        <th>Unidades necessárias</th>
        <th>Custo (R$)</th>
        <th>Ações</th>
      `
    } else if (unit === "un") {
      thead.innerHTML = `
        <th>Item</th>
        <th>Unidades</th>
        <th>Peso (g)</th>
        <th>Custo (R$)</th>
        <th>Ações</th>
      `
    } else if (unit === "m2") {
      thead.innerHTML = `
        <th>Item</th>
        <th>Área (m²)</th>
        <th>Peso (g)</th>
        <th>Custo (R$)</th>
        <th>Ações</th>
      `
    } else {
      thead.innerHTML = `
        <th>Item</th>
        <th>Quantidade</th>
        <th>Custo (R$)</th>
        <th>Peso (g)</th>
        <th>Ações</th>
      `
    }
  }

  renderSubproductFields(e) {
    const block = e.target.closest("tr[data-controller='composition-row']")
    if (!block) return
    const selectedId = e.target.value
    const unit = e.target.selectedOptions[0]?.dataset.unit?.trim().toLowerCase()
    if (!unit) return
    let partialId = null
    if (unit === "g" || unit === "ml") partialId = "template-subproduct-weight"
    else if (unit === "un") partialId = "template-subproduct-unit"
    else if (unit === "m2") partialId = "template-subproduct-m2"
    else return
    const tpl = document.getElementById(partialId)
    if (!tpl) return
    const frag = tpl.content.cloneNode(true)
    const newBlock = frag.querySelector("tr")
    if (!newBlock) return
    newBlock.innerHTML = newBlock.innerHTML.replace(/NEW_RECORD/g, Date.now())
    block.replaceWith(newBlock)
    const newSelect = newBlock.querySelector("select[name*='[subproduct_id]']")
    if (newSelect) newSelect.value = selectedId
    newBlock.dataset.unit = unit
    this.updateHeader(unit)
    newBlock.dispatchEvent(new CustomEvent("row:updated", { bubbles: true }))
    this.refreshAll()
  }

  renderInputFields(e) {
    const block = e.target.closest("tr[data-controller='composition-row']")
    if (!block) return
    const selectedId = e.target.value
    const unit = e.target.selectedOptions[0]?.dataset.unit?.trim().toLowerCase()
    if (!unit) return
    let partialId = null
    if (unit === "g" || unit === "ml") partialId = "template-input-weight"
    else if (unit === "un") partialId = "template-input-unit"
    else if (unit === "m2") partialId = "template-input-m2"
    else return
    const tpl = document.getElementById(partialId)
    if (!tpl) return
    const frag = tpl.content.cloneNode(true)
    const newBlock = frag.querySelector("tr")
    if (!newBlock) return
    newBlock.innerHTML = newBlock.innerHTML.replace(/NEW_RECORD/g, Date.now())
    block.replaceWith(newBlock)
    const newSelect = newBlock.querySelector("select[name*='[input_id]']")
    if (newSelect) newSelect.value = selectedId
    newBlock.dataset.unit = unit
    this.updateHeader(unit)
    newBlock.dispatchEvent(new CustomEvent("row:updated", { bubbles: true }))
    this.refreshAll()
  }

  toggleFinalizeButton() {
    const hasRows = this.listTarget.querySelectorAll("tr[data-controller='composition-row']").length > 0
    if (hasRows) {
      this.finalizeButtonTarget.classList.remove("d-none")
    } else {
      this.finalizeButtonTarget.classList.add("d-none")
    }
  }
}