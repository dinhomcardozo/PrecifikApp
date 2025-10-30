// app/javascript/controllers/product_composition_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "list",
    "template",
    "fieldCost",
    "weightLoss",
    "grossWeight",
    "finalWeight"
  ]

  connect() {
    this.element.addEventListener("row:updated", () => this.recalcWeights())
    this.refreshAll()
  }

  // Botão: adicionar subproduto
  addSubproduct(e) {
    e.preventDefault()
    const tpl = document.getElementById("template-subproduct")
    if (!tpl) return
    const html = tpl.innerHTML.replace(/NEW_RECORD/g, Date.now())
    this.listTarget.insertAdjacentHTML("beforeend", html)
    this.refreshAll()
  }

  // Botão: adicionar input
  addInput(e) {
    e.preventDefault()
    const tpl = document.getElementById("template-input")
    if (!tpl) return
    const html = tpl.innerHTML.replace(/NEW_RECORD/g, Date.now())
    this.listTarget.insertAdjacentHTML("beforeend", html)
    this.refreshAll()
  }

  // Remover linha
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

  // Recalcular custo de uma linha
  recalculateCost(e) {
    const row = e.target.closest("tr")
    const qty = parseFloat(row.querySelector("input[name*='[quantity]']")?.value) || 0
    const opt = row.querySelector("select option:checked")
    if (!opt) return

    // lê os data-* do option
    const unit = opt.dataset.unit
    const cpg  = parseFloat(opt.dataset.costPerGram) || 0
    const cpu  = parseFloat(opt.dataset.costPerUnit) || 0
    const cpm2 = parseFloat(opt.dataset.costPerM2)   || 0

    let cost = 0
    if (unit === "g" || unit === "ml") cost = qty * cpg
    else if (unit === "un") cost = qty * cpu
    else if (unit === "m2") cost = qty * cpm2

    const costField = row.querySelector("input[name*='[cost]']")
    if (costField) costField.value = cost.toFixed(2)

    const fieldCost = row.querySelector("[data-product-composition-target='fieldCost']")
    if (fieldCost) fieldCost.textContent = cost.toFixed(2)

    this.recalcWeights()
  }

  // Atualizar todos os custos
  refreshAll() {
    this.listTarget.querySelectorAll("[data-action*='recalculateCost']").forEach(el => {
      el.dispatchEvent(new Event("input", { bubbles: true }))
    })
    this.recalcWeights()
  }

  // Recalcular totais
  recalcWeights() {
    const qtyEls = this.listTarget.querySelectorAll("input[name*='[quantity]']")
    const gross = Array.from(qtyEls).reduce((s, el) => s + (parseFloat(el.value) || 0), 0)

    const lossPct = parseFloat(this.weightLossTarget?.value) || 0
    const ratio   = Math.max(0, Math.min(100, 100 - lossPct)) / 100
    const finalW  = gross * ratio

    if (this.grossWeightTarget) this.grossWeightTarget.value = gross.toFixed(4)
    if (this.finalWeightTarget) this.finalWeightTarget.value = finalW.toFixed(4)
  }
}