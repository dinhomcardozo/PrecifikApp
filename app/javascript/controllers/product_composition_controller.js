import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { template: String }
  static targets = ["list", "template", "fieldCost"]

  connect() {
    this.updateAllCosts()
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
    const row = e.target.closest("tr")

    // 1) pega quantidade
    const qtyField = row.querySelector("input[name*='[quantity]']")
    const qty = parseFloat(qtyField.value) || 0

    // 2) pega option selecionada e lê data-cost-per-gram
    const select = row.querySelector("select[name*='[subproduct_id]']")
    const selectedOption = select.options[select.selectedIndex]
    const costPerGram = parseFloat(selectedOption.dataset.costPerGram) || 0

    // 3) calcula e aplica
    const cost = (qty * costPerGram).toFixed(2)
    row.querySelector("input[name*='[cost]']").value = cost
    row.querySelector("[data-product-composition-target='fieldCost']").textContent = cost
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
  }

  refreshAll(e) {
    e.preventDefault()
    this.listTarget
      .querySelectorAll("input[name*='[quantity]']")
      .forEach(input => input.dispatchEvent(new Event("input", { bubbles: true })))
    this.listTarget
      .querySelectorAll("select[name*='[subproduct_id]']")
      .forEach(select => select.dispatchEvent(new Event("change", { bubbles: true })))
  }
}