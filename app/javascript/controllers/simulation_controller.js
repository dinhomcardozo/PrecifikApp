import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["productSelect", "quantityField"]

  updateTables() {
    const productId = this.productSelectTarget.value
    const quantity = this.quantityFieldTarget.value

    if (!productId || !quantity) {
      this.clearTables()
      return
    }

    fetch(`/clients/production_simulations/calculate?product_id=${productId}&quantity=${quantity}`, {
      headers: { "Accept": "application/json" }
    })
      .then(res => res.json())
      .then(data => {
        this.fillInputsTable(data.inputs)
        this.fillSubproductsTable(data.subproducts)
        this.fillProductTable(data.product)
      })
      .catch(err => console.error("Erro ao buscar dados da simulação:", err))
  }

  fillInputsTable(inputs) {
    const tbody = document.querySelector("#inputs-table tbody")
    tbody.innerHTML = inputs.map(i => `
      <tr>
        <td>${i.name}</td>
        <td>${i.total_quantity}</td>
        <td>${i.total_cost}</td>
        <td>${i.required_units}</td>
      </tr>
    `).join("")
  }

  fillSubproductsTable(subproducts) {
    const tbody = document.querySelector("#subproducts-table tbody")
    tbody.innerHTML = subproducts.map(sp => `
      <tr>
        <td>${sp.name}</td>
        <td>${sp.total_quantity}</td>
        <td>${sp.total_cost}</td>
      </tr>
    `).join("")
  }

  fillProductTable(product) {
    const tbody = document.querySelector("#product-table tbody")
    tbody.innerHTML = `
      <tr>
        <td>${product.total_quantity}</td>
        <td>${product.total_cost}</td>
        <td>${product.minimum_selling_price}</td>
        <td>${product.total_selling_price}</td>
        <td>${product.total_retail_profit}</td>
        <td>${product.total_wholesale_profit}</td>
      </tr>
    `
  }

  clearTables() {
    document.querySelector("#inputs-table tbody").innerHTML = ""
    document.querySelector("#subproducts-table tbody").innerHTML = ""
    document.querySelector("#product-table tbody").innerHTML = ""
  }
}