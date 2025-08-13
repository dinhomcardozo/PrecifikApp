import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values  = { association: String }
  static targets = ["items", "template", "item", "cost"]

    add(event) {
    event.preventDefault()
    const newId   = new Date().getTime()
    const pattern = new RegExp("NEW_" + this.associationValue, "g")
    const content = this.templateTarget.innerHTML.replace(pattern, newId)
    this.itemsTarget.insertAdjacentHTML("beforeend", content)
  }

    remove(event) {
    event.preventDefault()
    const wrapper = event.currentTarget.closest("[data-service-nested-form-target='item']")
    wrapper.querySelector("input.destroy-flag").value = "1"
    wrapper.style.display = "none"
    this.dispatchCostChange()
  }

  loadCost(event) {
    // executa quando seleciona o item (input, subproduct, product ou energy/equipment)
    this._loadUnitCost(event.currentTarget)
  }

  updateCost(event) {
    // executa quando muda quantity_for_service ou hours_per_service
    this._calcLineCost(event.currentTarget)
  }

  _loadUnitCost(selectEl) {
    const id  = selectEl.value
    const wrapper = selectEl.closest("[data-service-nested-form-target='item']")
    const costEl  = wrapper.querySelector("[data-service-nested-form-target='cost']")

    if (!id) {
      costEl.value = ""
      this.dispatchCostChange()
      return
    }

    // `/inputs/:id.json` deve retornar `{ cost_per_unit: ... }`
    fetch(`/${this.associationValue}/${id}.json`, {
      headers: { "Accept": "application/json" }
    })
      .then(r => r.json())
      .then(data => {
        // guarda custo unitário no wrapper para recálculos
        wrapper.dataset.unitCost = data.cost_per_unit
        this._calcLineCost(selectEl)
      })
  }

  _calcLineCost(changedEl) {
    const wrapper  = changedEl.closest("[data-service-nested-form-target='item']")
    const unitCost = parseFloat(wrapper.dataset.unitCost)    || 0
    const qtyField = wrapper.querySelector("input[name*='quantity_for_service'], input[name*='hours_per_service']")
    const qty      = parseFloat(qtyField.value) || 0
    const costEl   = wrapper.querySelector("[data-service-nested-form-target='cost']")
    const lineCost = (unitCost * qty).toFixed(2)

    costEl.value = lineCost
    this.dispatchCostChange()
  }

  dispatchCostChange() {
    this.element.dispatchEvent(new CustomEvent("nested-costs-changed", { bubbles: true }))
  }
}