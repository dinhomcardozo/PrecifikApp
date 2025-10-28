import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "weightContainer",
    "unitContainer",
    "quantityCostField",
    "costDisplay",
    "requireUnitsDisplay",
    "requireUnitsField"
  ]

  connect() {
    console.log("NestedForm conectado, somando itens existentes")
    this.updateTotal()
  }

  addField(event) {
    event.preventDefault()
    const templateId = event.currentTarget.dataset.templateId
    const containerTarget = event.currentTarget.dataset.containerTarget
    const tpl = document.getElementById(templateId)

    if (!tpl) {
      console.error(`NestedForm: template #${templateId} não encontrado`)
      return
    }

    const newId = Date.now()
    const html  = tpl.innerHTML.replace(/NEW_RECORD/g, newId)
    this[containerTarget + "Target"].insertAdjacentHTML("beforeend", html)
    this.updateTotal()
  }

  removeField(e) {
    e.preventDefault()
    const row = e.target.closest("tr")
    row.querySelector('input[name*="[_destroy]"]').value = 1
    row.style.display = "none"
    this.updateTotal()
  }

  updateCost(e) {
  const row = e.target.closest("tr")
  const select = row.querySelector("select")
  const inputId = select.value

  const costDisplay = row.querySelector("[data-nested-form-target='costDisplay']")
  const hiddenQc    = row.querySelector("[data-nested-form-target='quantityCostField']")

  const requireUnitsInput = row.querySelector("[data-nested-form-target='requireUnitsField']")
  const quantityDisplay   = row.querySelector("[data-nested-form-target='quantityDisplay']")
  const weightQtyInput    = row.querySelector("[data-nested-form-target='weightQuantityInput']")
  const unitQtyInput      = row.querySelector("[data-nested-form-target='unitQuantityInput']")

  if (!inputId) return

  fetch(`/clients/inputs/${inputId}.json`, { headers: { Accept: "application/json" } })
    .then(r => r.json())
    .then(data => {
      const cost   = data.cost || 0
      const weight = data.weight_in_grams || data.weight || 1

      if (requireUnitsInput && unitQtyInput) {
        // lógica para insumos em unidades
        const requireUnits = parseFloat(requireUnitsInput.value || 0)
        const totalQuantity = weight * requireUnits
        const totalCost = cost * requireUnits

        if (quantityDisplay) quantityDisplay.textContent = totalQuantity
        unitQtyInput.value = totalQuantity
        if (hiddenQc) hiddenQc.value = totalCost
        if (costDisplay) costDisplay.textContent = `R$ ${totalCost.toFixed(2)}`
      } else if (weightQtyInput) {
        // lógica para insumos em peso
        const quantity = parseFloat(weightQtyInput.value || 0)
        const unitCost = cost / weight

        const totalCost = unitCost * quantity
        const requireUnits = quantity / weight

        if (hiddenQc) hiddenQc.value = totalCost
        if (costDisplay) costDisplay.textContent = `R$ ${totalCost.toFixed(2)}`
        if (requireUnitsInput) requireUnitsInput.value = requireUnits
        const requireUnitsDisplay = row.querySelector("[data-nested-form-target='requireUnitsDisplay']")
        if (requireUnitsDisplay) requireUnitsDisplay.textContent = requireUnits.toFixed(2)
      }

      this.updateTotal()
    })
  }

  updateTotal() {
    // soma dos insumos em peso
    let weightInputs = []
    if (this.hasWeightContainerTarget) {
      weightInputs = Array.from(
        this.weightContainerTarget.querySelectorAll('input[data-nested-form-target="quantityCostField"]')
      )
    }
    const weightSum = weightInputs.reduce((acc, el) => acc + (parseFloat(el.value) || 0), 0)
    const weightTotalElem = document.getElementById("subproduct_total_cost_weight")
    if (weightTotalElem) {
      weightTotalElem.textContent = `Custo Total: R$ ${weightSum.toFixed(2)}`
    }

    // soma dos insumos em unidades
    let unitInputs = []
    if (this.hasUnitContainerTarget) {
      unitInputs = Array.from(
        this.unitContainerTarget.querySelectorAll('input[data-nested-form-target="quantityCostField"]')
      )
    }
    const unitSum = unitInputs.reduce((acc, el) => acc + (parseFloat(el.value) || 0), 0)
    const unitTotalElem = document.getElementById("subproduct_total_cost_units")
    if (unitTotalElem) {
      unitTotalElem.textContent = `Custo Total: R$ ${unitSum.toFixed(2)}`
    }
  }

  blockedField(e) {
    e.preventDefault()
    alert("Ops! Tarde demais. Este insumo já está sendo utilizado por subprodutos. É possível editar seu peso, nome, fornecedor e outras informações, mas não pode mudar sua unidade de medida ou alterar seu status de um produto para revenda. Crie outro insumo se necessário.")
  }
}