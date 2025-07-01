import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("composition:changed", () => this.recalculate())
    // se quiser reagir também aos inputs de custos agregados
    document.querySelectorAll("[data-action*='product-pricing#recalculate']").forEach(el => {
      el.addEventListener("input", () => this.recalculate())
    })
  }

  recalculate() {
    // aqui você refaz os cálculos totais de preços/lucros
    // e atualiza a aba de pricing se estiver visível.
    // Exemplo:
    const totalCost = parseFloat( document.querySelector("[data-product-pricing-target='totalCost']").textContent ) || 0
    // ...
  }
}