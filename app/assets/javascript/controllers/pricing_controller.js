import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["grossWholesale", "grossRetail", "netRetail", "netWholesale", "fullCost", "wholesalePrice", "retailPrice"]

  // Esse controller teria métodos para calcular as margens e preços automaticamente.
  // Você pode chamar um método updatePrices() quando os valores relevantes mudarem.
  updatePrices() {
    // Exemplo: utilize valores dos campos (que podem ser obtidos via data attributes ou via query selectors)
    // Este é apenas um exemplo genérico.
    const totalCost = parseFloat(document.querySelector("[data-target='composition.totalCost']").textContent) || 0;
    const financialCost = parseFloat(document.querySelector("#aggregated-costs input[name='product[financial_cost]']").value) || 0;
    // Outras variáveis: sales_channel_cost, commission_cost, freight_cost, storage_cost, margens, etc.
    // Calcule os indicadores, por exemplo:
    const fullCost = totalCost + financialCost; // Exemplo simples
    const marginWholesale = parseFloat(document.querySelector("#product_configurations input[name='product[profit_margin_wholesale]']").value) || 0;
    const wholesalePrice = fullCost * (1 + marginWholesale / 100);

    // Atualize os targets:
    this.fullCostTarget.textContent = fullCost.toFixed(2);
    this.wholesalePriceTarget.textContent = wholesalePrice.toFixed(2);

    // Em uma implementação real, você faria todos os cálculos (margem bruta, líquida, varejo, etc.)
  }
}