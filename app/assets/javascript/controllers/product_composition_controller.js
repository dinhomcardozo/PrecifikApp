// app/javascript/controllers/product_composition_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "list",         // <tbody> que recebe as linhas
    "template",     // <template> oculto para clonar linhas
    "totalWeight",  // <th> ou <span> onde exibe peso total
    "totalCost"     // <th> ou <span> onde exibe custo total
  ];

  addField(event) {
    event.preventDefault();
    const clone = this.templateTarget.content.cloneNode(true);
    this.listTarget.appendChild(clone);
    this.updateTotals();
  }

  removeField(event) {
    event.preventDefault();
    const row = event.currentTarget.closest("tr");
    if (row) {
      row.remove();
      this.updateTotals();
    }
  }

  // Disparado por click em “Atualizar” ou por change/input nos campos
  updateCost(event) {
    event.preventDefault();
    const row = event.currentTarget.closest("tr");
    const qtyEl    = row.querySelector(".composition-quantity");
    const selectEl = row.querySelector("[data-cost-per-gram]");
    const costEl   = row.querySelector("[data-target='product-composition.fieldCost']");

    const costPerGram = parseFloat(selectEl.dataset.costPerGram) || 0;
    const quantity    = parseFloat(qtyEl.value)              || 0;
    const lineCost    = costPerGram * quantity;

    costEl.textContent = lineCost.toFixed(2);
    this.updateTotals();
  }

  // Soma peso e custo de todas as linhas e atualiza os targets
  updateTotals() {
    let totalW = 0;
    let totalC = 0;

    this.listTarget.querySelectorAll("tr").forEach(row => {
      const qty   = parseFloat(row.querySelector(".composition-quantity").value) || 0;
      const cost  = parseFloat(
                      row.querySelector("[data-target='product-composition.fieldCost']").textContent
                    ) || 0;

      totalW += qty;
      totalC += cost;
    });

    this.totalWeightTarget.textContent = totalW.toFixed(2);
    this.totalCostTarget.textContent   = totalC.toFixed(2);
  }
}