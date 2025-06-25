// app/javascript/controllers/product_composition_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list", "totalWeight", "totalCost"];

  // Quando o usuário clicar em "Adicionar Subproduto"
  addField(event) {
    event.preventDefault();
    const template = document.querySelector("#new-product-subproduct");
    if (!template) return;
    const clone = template.content.cloneNode(true);
    this.listTarget.appendChild(clone);
    this.updateTotals();
  }

  // Ao clicar em "Remover"
  removeField(event) {
    event.preventDefault();
    const row = event.currentTarget.closest("tr");
    if (row) {
      row.remove();
      this.updateTotals();
    }
  }

  // Sempre que mudar o select ou quantidade
  updateCost(event) {
    const row = event.currentTarget.closest("tr");
    const quantityField = row.querySelector(".composition-quantity");
    const selectField   = row.querySelector(".form-select");
    const costDisplay   = row.querySelector("[data-target='product-composition.fieldCost']");

    const costPerGram = parseFloat(selectField.dataset.costPerGram || "0");
    const quantity    = parseFloat(quantityField.value || "0");
    const lineCost    = costPerGram * quantity;

    if (costDisplay) {
      costDisplay.textContent = lineCost.toFixed(2);
    }

    this.updateTotals();
  }

  // Recalcula os totais de peso e custo de TODAS as linhas
  updateTotals() {
    let totalWeight = 0;
    let totalCost   = 0;

    this.listTarget.querySelectorAll("tr").forEach(row => {
      const qty = parseFloat(row.querySelector(".composition-quantity").value || "0");
      totalWeight += qty;

      const costText = row.querySelector("[data-target='product-composition.fieldCost']").textContent;
      const lineCost = parseFloat(costText) || 0;
      totalCost   += lineCost;
    });

    this.totalWeightTarget.textContent = totalWeight.toFixed(2);
    this.totalCostTarget.textContent   = totalCost.toFixed(2);
  }
}
