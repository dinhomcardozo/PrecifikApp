// app/javascript/controllers/product_composition_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("✔️ product-composition controller conectado");
    this.updateTotals();
  }
  static targets = [
    "list",         // <tbody> que recebe as linhas
    "template",     // <template> oculto para clonar linhas
    "totalWeight",  // <th> ou <span> onde exibe peso total
    "totalCost",    // <th> ou <span> onde exibe custo total
    "fieldCost"     // celular de custo do subproduto em cada linha
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
  updateCost(e) {
    e.preventDefault()
    const row        = e.currentTarget.closest("tr")
    const select     = row.querySelector("select")
    const qtyInput   = row.querySelector("input[name*='[quantity]']")
    const costInput  = row.querySelector("input[name*='[cost]']")
    const costSpan   = row.querySelector("[data-product-composition-target='fieldCost']")

    // custo por grama vem do data-cost-per-gram
    const costPerGram = parseFloat(select.dataset.costPerGram) || 0
    const quantity    = parseFloat(qtyInput.value) || 0

    const cost = costPerGram * quantity

    // atualiza o input hidden e o span
    costInput.value    = cost.toFixed(2)
    costSpan.textContent = cost.toFixed(2)

    // recalcula totais na tabela
    this.updateTotals()
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