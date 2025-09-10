import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { template: String }
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
    this.updateAllCosts()
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
    const qty   = parseFloat(row.querySelector("input[name*='[quantity]']").value) || 0
    const opt   = row.querySelector("select[name*='[subproduct_id]']")
    const costPerGram = parseFloat(opt.selectedOptions[0].dataset.costPerGram) || 0
    const cost  = (qty * costPerGram).toFixed(2)

    row.querySelector("input[name*='[cost]']").value = cost
    row.querySelector("[data-product-composition-target='fieldCost']").textContent = cost

    this.recalcWeights()
  }

  updateAllCosts() {
    this.listTarget.querySelectorAll("[data-action*='recalculate']").forEach(input => {
      input.dispatchEvent(new Event("input"))
    })
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