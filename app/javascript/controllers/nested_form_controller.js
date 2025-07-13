// app/javascript/controllers/nested_form_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "quantityCostField", "costDisplay"];

  addField(e) {
    e.preventDefault();
    const content = e.target.dataset.fields.replace(/NEW_RECORD/g, e.target.dataset.id);
    this.containerTarget.insertAdjacentHTML("beforeend", content);
  }

  removeField(e) {
    e.preventDefault();
    const row = e.target.closest("tr");
    row.querySelector('input[name*="_destroy"]').value = 1;
    row.style.display = "none";
  }

  updateCost(e) {
    const row           = e.target.closest("tr");
    const select        = row.querySelector("select");
    const qtyInput      = row.querySelector('input[type="number"]');
    const costDisplay   = row.querySelector(".cost-display");
    const hiddenQcField = row.querySelector('input[name*="[quantity_cost]"]');

    // captura os valores
    const inputId  = select.value;
    const quantity = parseFloat(qtyInput.value);

    // validações iniciais
    if (!inputId || isNaN(quantity) || quantity <= 0) {
      costDisplay.textContent = "-";
      if (hiddenQcField) hiddenQcField.value = "";
      return;
    }

    // busca o JSON do input
    fetch(`/inputs/${inputId}.json`)
      .then(response => response.json())
      .then(data => {
        // calcula custo: data.cost / data.weight_in_grams * quantity
        const unitCost      = (data.cost  || 0) / (data.weight_in_grams || 1);
        const computedCost  = unitCost * quantity;
        const formattedCost = computedCost.toFixed(2);

        // atualiza célula visível
        costDisplay.textContent = computedCost > 0
          ? `R$ ${formattedCost}`
          : "-";

        // alimenta o hidden field para envio no form
        if (hiddenQcField) {
          hiddenQcField.value = formattedCost;
        }
      })
      .catch(() => {
        costDisplay.textContent = "-";
        if (hiddenQcField) hiddenQcField.value = "";
      });
  }
}
