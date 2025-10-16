import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "productSelect",
    "productUnitsField",
    "quantityField",
    "quantityKgField"
  ]

  connect() {
    this.updateTables = this.debounce(this.updateTables.bind(this), 500)
  }

  debounce(func, wait) {
    let timeout
    return (...args) => {
      clearTimeout(timeout)
      timeout = setTimeout(() => func.apply(this, args), wait)
    }
  }

  updateFromUnits() {
    const units = parseFloat(this.productUnitsFieldTarget.value) || 0
    const selectedOption = this.productSelectTarget.selectedOptions[0]
    const finalWeight = parseFloat(selectedOption?.dataset.finalWeight) || 0

    const totalGrams = units * finalWeight
    const totalKg = totalGrams / 1000

    this.quantityFieldTarget.value = totalGrams.toFixed(2)
    this.quantityKgFieldTarget.value = totalKg.toFixed(3)

    this.updateTables()
  }

  updateTables() {
    const portionId = this.productSelectTarget.value
    const units = parseFloat(this.productUnitsFieldTarget.value) || 0

    if (!portionId || units <= 0) {
      this.clearTables()
      return
    }

    fetch(`/clients/production_simulations/calculate?product_portion_id=${portionId}&product_units=${units}`, {
      headers: { "Accept": "application/json" }
    })
      .then(res => {
        if (!res.ok) throw new Error(`Erro HTTP ${res.status}`)
        return res.json()
      })
      .then(data => {
        this.fillInputsTable(data.inputs)
        this.fillSubproductsTable(data.subproducts)
        this.fillProductTable(data.product)
      })
      .catch(err => {
        console.error("Erro ao buscar dados da simulação:", err)
        this.clearTables()
      })
  }


  fillInputsTable(inputs) {
    const tbody = document.querySelector("#inputs-table tbody")
    tbody.innerHTML = inputs.map((i, index) => `
      <tr>
        <td>${i.name}</td>
        <td>${i.total_quantity}</td>
        <td>${i.total_cost}</td>
        <td>${i.required_units}</td>

        <input type="hidden" name="production_simulation[simulation_inputs_attributes][${index}][input_id]" value="${i.id}">
        <input type="hidden" name="production_simulation[simulation_inputs_attributes][${index}][total_quantity]" value="${i.total_quantity}">
        <input type="hidden" name="production_simulation[simulation_inputs_attributes][${index}][total_cost]" value="${i.total_cost_raw}">
        <input type="hidden" name="production_simulation[simulation_inputs_attributes][${index}][required_units]" value="${i.required_units}">
      </tr>
    `).join("")
  }

  fillSubproductsTable(subproducts) {
    const tbody = document.querySelector("#subproducts-table tbody")
    tbody.innerHTML = subproducts.map((sp, index) => `
      <tr>
        <td>${sp.name}</td>
        <td>${sp.total_quantity}</td>
        <td>${sp.total_cost}</td>

        <input type="hidden" name="production_simulation[simulation_subproducts_attributes][${index}][subproduct_id]" value="${sp.id}">
        <input type="hidden" name="production_simulation[simulation_subproducts_attributes][${index}][total_quantity]" value="${sp.total_quantity}">
        <input type="hidden" name="production_simulation[simulation_subproducts_attributes][${index}][total_cost]" value="${sp.total_cost_raw}">
      </tr>
    `).join("")
  }

  fillProductTable(product) {
    const tbody = document.querySelector("#product-table tbody")

    tbody.innerHTML = `
      <tr>
        <td>${product.total_quantity}</td>
        <td>${product.product_units}</td>
        <td>${product.total_cost}</td>
        <td>${product.minimum_selling_price}</td>
        <td>${product.total_selling_price}</td>
        <td>${product.total_retail_profit}</td>
        <td>${product.total_wholesale_profit}</td>
        <td style="display:none;">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][product_portion_id]" value="${this.productSelectTarget.value}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][total_quantity]" value="${product.total_quantity}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][total_cost]" value="${product.total_cost_raw}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][minimum_selling_price]" value="${product.minimum_selling_price_raw}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][total_selling_price]" value="${product.total_selling_price_raw}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][total_retail_profit]" value="${product.total_retail_profit_raw}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][total_wholesale_profit]" value="${product.total_wholesale_profit_raw}">
        </td>
      </tr>
    `
  }
  clearTables() {
    document.querySelector("#inputs-table tbody").innerHTML = ""
    document.querySelector("#subproducts-table tbody").innerHTML = ""
    document.querySelector("#product-table tbody").innerHTML = ""
  }
}