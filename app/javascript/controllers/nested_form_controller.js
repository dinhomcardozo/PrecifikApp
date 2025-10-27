// app/javascript/controllers/nested_form_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "quantityCostField", "costDisplay", "requireUnitsDisplay"];

  connect() {
    console.log("NestedForm conectado, somando itens existentes");
    this.updateTotal();
  }

  addField(event) {
    event.preventDefault();

    // pega o ID do <template> via data-template-id
    const templateId = event.currentTarget.dataset.templateId;
    const tpl = document.getElementById(templateId);

    if (!tpl) {
      console.error(`NestedForm: template #${templateId} não encontrado`);
      return;
    }

    // clona o conteúdo do template, substitui NEW_RECORD e insere
    const newId = Date.now();
    const html  = tpl.innerHTML.replace(/NEW_RECORD/g, newId);
    this.containerTarget.insertAdjacentHTML("beforeend", html);

    this.updateTotal();
  }

  removeField(e) {
    e.preventDefault();
    const row = e.target.closest("tr");
    // marca pra remoção no nested_attributes
    row.querySelector('input[name*="[_destroy]"]').value = 1;
    row.style.display = "none";
    this.updateTotal();
  }

  updateCost(e) {
  const row         = e.target.closest("tr");
  const select      = row.querySelector("select");
  const qtyInput    = row.querySelector('input[type="number"]');
  const costDisplay = row.querySelector("[data-nested-form-target='costDisplay']");
  const hiddenQc    = row.querySelector("[data-nested-form-target='quantityCostField']");
  const hiddenRu    = row.querySelector("[data-nested-form-target='requireUnitsField']"); // 🔑 aqui
  const requireUnitsDisplay = row.querySelector("[data-nested-form-target='requireUnitsDisplay']");

  const inputId  = select.value;
  const quantity = parseFloat(qtyInput.value);

// validações iniciais
  if (!inputId || isNaN(quantity) || quantity <= 0) {
    costDisplay.textContent = "-";
    if (hiddenQc) hiddenQc.value = "";
    if (hiddenRu) hiddenRu.value = "";
    if (requireUnitsDisplay) requireUnitsDisplay.textContent = "-";
    this.updateTotal();
    return;
  }

    fetch(`/clients/inputs/${inputId}.json`, { headers: { Accept: "application/json" } })
    .then(r => r.json())
    .then(data => {
      const unitCost     = (data.cost || 0) / (data.weight_in_grams || 1);
      const computedCost = (unitCost * quantity).toFixed(2);

      costDisplay.textContent = computedCost > 0 ? `R$ ${computedCost}` : "-";
      if (hiddenQc) hiddenQc.value = computedCost;

      if (data.weight_in_grams && data.weight_in_grams > 0) {
        const requireUnits = (quantity / data.weight_in_grams).toFixed(2);
        if (requireUnitsDisplay) requireUnitsDisplay.textContent = requireUnits;
        if (hiddenRu) hiddenRu.value = requireUnits;
      } else {
        if (requireUnitsDisplay) requireUnitsDisplay.textContent = "-";
        if (hiddenRu) hiddenRu.value = "";
      }

      this.updateTotal();
    })
     .catch(() => {
      costDisplay.textContent = "-";
      if (hiddenQc) hiddenQc.value = "";
      if (hiddenRu) hiddenRu.value = "";
      if (requireUnitsDisplay) requireUnitsDisplay.textContent = "-";
      this.updateTotal();
    });
  }

  updateTotal() {
    const inputs = Array.from(
      this.containerTarget.querySelectorAll('input[data-nested-form-target="quantityCostField"]')
    );
    const sum = inputs.reduce((acc, el) => acc + (parseFloat(el.value) || 0), 0);
    const totalElem = document.getElementById("subproduct_total_cost");
    if (totalElem) {
      totalElem.textContent = `Custo Total: R$ ${sum.toFixed(2)}`;
    }
  }
}