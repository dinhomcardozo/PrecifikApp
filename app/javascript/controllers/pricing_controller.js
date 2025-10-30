import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "template", "fieldCost", "weightLoss", "grossWeight", "finalWeight"]

  connect() {
    this.element.addEventListener("row:updated", () => this.recalcWeights())
    this.refreshAll()
  }

  removeField(e) {
    e.preventDefault()
    const row = e.currentTarget.closest("tr")
    if (row.dataset.newRecord === "true") {
      row.remove()
    } else {
      row.querySelector("input[name*='_destroy']").value = 1
      row.style.display = "none"
    }
    this.refreshAll()
  }

  recalculateCost(e) {
    const row = e.target.closest("tr")
    const qty = parseFloat(row.querySelector("input[name*='[quantity]']").value) || 0
    const type = row.dataset.type   // "subproduct" ou "input"
    const unit = row.dataset.unit   // "g", "un", "m2"

    let cost = 0

    if (type === "subproduct") {
      const opt = row.querySelector("select[name*='[subproduct_id]']")
      const costPerGram = parseFloat(opt?.selectedOptions[0]?.dataset.costPerGram) || 0
      cost = qty * costPerGram
    } else if (type === "input") {
      const opt = row.querySelector("select[name*='[input_id]']")
      if (unit === "g" || unit === "ml") {
        const costPerGram = parseFloat(opt?.selectedOptions[0]?.dataset.costPerGram) || 0
        cost = qty * costPerGram
      } else if (unit === "un") {
        const costPerUnit = parseFloat(opt?.selectedOptions[0]?.dataset.costPerUnit) || 0
        cost = qty * costPerUnit
      } else if (unit === "m2") {
        const costPerM2 = parseFloat(opt?.selectedOptions[0]?.dataset.costPerM2) || 0
        cost = qty * costPerM2
      }
    }

    row.querySelector("input[name*='[cost]']").value = cost.toFixed(2)
    const fieldCost = row.querySelector("[data-product-composition-target='fieldCost']")
    if (fieldCost) fieldCost.textContent = cost.toFixed(2)

    this.recalcWeights()
  }

  addField(e) {
    e.preventDefault()
    const html = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now())
    this.listTarget.insertAdjacentHTML("beforeend", html)
    this.refreshAll()
  }

  refreshAll() {
    this.listTarget.querySelectorAll("[data-action*='recalculateCost']").forEach(el => {
      el.dispatchEvent(new Event("input", { bubbles: true }))
    })
    this.recalcWeights()
  }

  recalcWeights() {
    const qtyEls = this.listTarget.querySelectorAll("input[name*='[quantity]']")
    const gross = Array.from(qtyEls).reduce((s, el) => s + (parseFloat(el.value) || 0), 0)

    const lossPct = parseFloat(this.weightLossTarget.value) || 0
    const ratio   = Math.max(0, Math.min(100, 100 - lossPct)) / 100
    const finalW  = gross * ratio

    this.grossWeightTarget.value = gross.toFixed(4)
    this.finalWeightTarget.value = finalW.toFixed(4)
  }
}