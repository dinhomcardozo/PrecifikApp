import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "fieldCost"]

  connect() {
    this.updateAllCosts()
  }

  addField(e) {
    e.preventDefault()
    const index   = Date.now()
    const template = this.element.querySelector("template").innerHTML
    const html     = template.replace(/NEW_RECORD/g, index)
    this.listTarget.insertAdjacentHTML("beforeend", html)
  }

  removeField(e) {
    e.preventDefault()
    const tr = e.currentTarget.closest("tr")
    tr.querySelector("input[name*='_destroy']").value = "1"
    tr.style.display = "none"
    this.dispatchChange()
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