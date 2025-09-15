import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["productSelect", "quantityField", "quantityKgField"]

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

  updateKgField() {
    const grams = parseFloat(this.quantityFieldTarget.value) || 0
    this.quantityKgFieldTarget.value = (grams / 1000).toFixed(3)
  }

  updateTables() {
    const productId = this.productSelectTarget.value
    const quantity = parseFloat(this.quantityFieldTarget.value)

    if (!productId || isNaN(quantity) || quantity <= 0) {
      this.clearTables()
      return
    }

    fetch(`/clients/production_simulations/calculate?product_id=${productId}&quantity=${quantity}`, {
      headers: { "Accept": "application/json" }
    })
      .then(res => {
        if (!res.ok) {
          // Lida com erro HTTP antes de tentar parsear
          throw new Error(`Erro HTTP ${res.status}`)
        }
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

    const totalQuantity        = product.total_quantity
    const productUnits         = product.product_units // novo campo vindo do back-end
    const totalCost            = product.total_cost
    const minPrice             = product.minimum_selling_price
    const totalSellingPrice    = product.total_selling_price
    const retailProfit         = product.total_retail_profit
    const wholesaleProfit      = product.total_wholesale_profit

    const totalCostRaw         = product.total_cost_raw
    const minPriceRaw          = product.minimum_selling_price_raw
    const totalSellingPriceRaw = product.total_selling_price_raw
    const retailProfitRaw      = product.total_retail_profit_raw
    const wholesaleProfitRaw   = product.total_wholesale_profit_raw

    tbody.innerHTML = `
      <tr>
        <td>${totalQuantity}</td>
        <td>${productUnits}</td> <!-- nova coluna -->
        <td>${totalCost}</td>
        <td>${minPrice}</td>
        <td>${totalSellingPrice}</td>
        <td>${retailProfit}</td>
        <td>${wholesaleProfit}</td>
        <td style="display:none;">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][product_id]" value="${this.productSelectTarget.value}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][total_quantity]" value="${totalQuantity}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][product_units]" value="${productUnits}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][total_cost]" value="${totalCostRaw}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][minimum_selling_price]" value="${minPriceRaw}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][total_selling_price]" value="${totalSellingPriceRaw}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][total_retail_profit]" value="${retailProfitRaw}">
          <input type="hidden" name="production_simulation[simulation_products_attributes][0][total_wholesale_profit]" value="${wholesaleProfitRaw}">
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