import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "costDisplay"]

  connect() {
    console.log("Formulário aninhado carregado");
  }

  addField(e) {
    e.preventDefault();

    const id = e.target.dataset.id;
    let fields = e.target.dataset.fields;

    fields = fields.replace(/NEW_RECORD/g, new Date().getTime());

    const tempDiv = document.createElement("div");
    tempDiv.innerHTML = fields;

    this.containerTarget.insertBefore(tempDiv.firstChild, e.target.closest("tr"));
  }

  removeField(e) {
    const row = e.target.closest("tr");
    if (row) row.remove();
    e.preventDefault();
  }

  updateCost(e) {
    const row = e.target.closest("tr");
    const select = row.querySelector("select");
    const input = e.target;
    const costDisplay = row.querySelector(".cost-display");

    if (!select || !input || !costDisplay) return;

    const inputId = select.value;
    const quantity = parseFloat(input.value);

    if (!inputId || isNaN(quantity) || quantity <= 0) {
      costDisplay.textContent = "-";
      return;
    }

    fetch(`/inputs/${inputId}.json`)
      .then(response => response.json())
      .then(inputData => {
        const totalCost = (inputData.cost * quantity) / 1000;
        costDisplay.textContent = `R$ ${totalCost.toFixed(2)}`;
      })
      .catch(() => {
        costDisplay.textContent = "-";
      });
  }
}