import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list", "totalWeight", "totalCost", "fieldCost"]

  addField(event) {
    event.preventDefault();
    // Suponha que exista um template oculto com o id "product_subproduct_template"
    const template = document.querySelector("#product_subproduct_template");
    if (template) {
      const clone = document.importNode(template.content, true);
      this.listTarget.appendChild(clone);
      this.updateTotals();
    }
  }

  removeField(event) {
    event.preventDefault();
    const row = event.currentTarget.closest("tr");
    if (row) {
      row.remove();
      this.updateTotals();
    }
  }

  updateCost(event) {
    const row = event.currentTarget.closest("tr");
    const quantityField = row.querySelector(".composition-quantity");
    const selectField = row.querySelector(".form-select");
    // Note que, agora, usamos data-target="product-composition.fieldCost" (em vez de "composition.fieldCost")
    const costDisplay = row.querySelector("[data-target='product-composition.fieldCost']");
    const costPerGram = parseFloat(selectField.dataset.costPerGram || "0");
    const quantity = parseFloat(quantityField.value || "0");
    const lineCost = costPerGram * quantity;
    costDisplay.textContent = lineCost.toFixed(2);
    this.updateTotals();
  }

  updateTotals() {
    let totalWeight = 0;
    let totalCost = 0;
    // Atualize os targets também para refletir o novo prefixo
    this.listTarget.querySelectorAll("tr").forEach(row => {
      const quantity = parseFloat(row.querySelector(".composition-quantity").value || "0");
      totalWeight += quantity;
      const lineCost = parseFloat(row.querySelector("[data-target='product-composition.fieldCost']").textContent) || 0;
      totalCost += lineCost;
    });
    this.totalWeightTarget.textContent = totalWeight;
    this.totalCostTarget.textContent = totalCost.toFixed(2);
  }
}