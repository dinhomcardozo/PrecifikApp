import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { template: String }
  static targets = ["list", "fieldCost"]

  connect() {
    this.updateAllCosts()
  }

  addField(e) {
    e.preventDefault()
    const html = this.templateTarget.innerHTML
                    .replace(/NEW_RECORD/g, Date.now())
    this.listTarget.insertAdjacentHTML("beforeend", html)
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
  }
  recalculate(e) {
    const tr     = e.currentTarget.closest("tr")
    const qty    = parseFloat(tr.querySelector("input[name*='[quantity]']").value) || 0
    const cpg    = parseFloat(
      tr.querySelector("select").dataset.costPerGram
    ) || 0
    const cost   = (qty * cpg).toFixed(2)

    tr.querySelector("input[name*='[cost]']").value = cost
    tr.querySelector("[data-product-composition-target='fieldCost']")
      .textContent = cost

    this.dispatchChange()
  }

  updateAllCosts() {
    this.listTarget.querySelectorAll("[data-action*='recalculate']").forEach(input => {
      input.dispatchEvent(new Event("input"))
    })
  }

  dispatchChange() {
    this.element.dispatchEvent(new CustomEvent("composition:changed"))
  }
}