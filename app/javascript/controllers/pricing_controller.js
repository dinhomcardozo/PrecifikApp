import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "taxSelect",
    "icms","ipi","pis_cofins","difal","iss","cbs","ibs",
    "totalCostWithTaxes","suggestedRetail","suggestedWholesale",
    "distributedFixedCostActive","totalCostWithFixedCosts"
  ]

  static values = {
    baseCost:    Number,  // total_cost dos subprodutos
    fixedCost:   Number,  // total_fixed_cost da sales_target
    activeSum:   Number,  // sales_target_active_sum
    marginRetail:    Number,
    marginWholesale: Number
  }

  connect() {
    this.fillTaxFields()
    this.recalculate()
  }

  // Preenche os campos de alíquotas a partir do dataset JSON do <select>
  fillTaxFields() {
    const opt = this.taxSelectTarget.selectedOptions[0]
    if (!opt) return
    const tax = JSON.parse(opt.dataset.json || "{}")

    this.icmsTarget.value       = (tax.icms || 0).toFixed(2)
    this.ipiTarget.value        = (tax.ipi || 0).toFixed(2)
    this.pis_cofinsTarget.value = (tax.pis_cofins || 0).toFixed(2)
    this.difalTarget.value      = (tax.difal || 0).toFixed(2)
    this.issTarget.value        = (tax.iss || 0).toFixed(2)
    this.cbsTarget.value        = (tax.cbs || 0).toFixed(2)
    this.ibsTarget.value        = (tax.ibs || 0).toFixed(2)
  }

  // Recalcula todos os valores derivados
  recalculate() {
    const baseCost  = this.baseCostValue    || 0
    const fixedCost = this.fixedCostValue   || 0
    const activeSum = this.activeSumValue   || 1

    const rates = [
      this.icmsTarget, this.ipiTarget, this.pis_cofinsTarget,
      this.difalTarget, this.issTarget, this.cbsTarget, this.ibsTarget
    ]

    // soma dos percentuais (ex: 0.18 para 18%)
    const sumRates = rates.reduce((acc, el) => {
      return acc + ((parseFloat(el.value) || 0) / 100)
    }, 0)

    // 1) Custo Fixo Distribuído Ativo
    const distributedActive = fixedCost / activeSum
    this.distributedFixedCostActiveTarget.value = distributedActive.toFixed(2)

    // 2) Custo Total + Fixo
    const totalWithFixed = baseCost + distributedActive
    this.totalCostWithFixedCostsTarget.value = totalWithFixed.toFixed(2)

    // 3) Total com tributos
    const totalWithTaxes = baseCost * (1 + sumRates)
    this.totalCostWithTaxesTarget.value = totalWithTaxes.toFixed(2)

    // 4) Preços sugeridos
    const retailFactor    = 1 + (this.marginRetailValue || 0) / 100
    const wholesaleFactor = 1 + (this.marginWholesaleValue || 0) / 100

    this.suggestedRetailTarget.value    = (totalWithTaxes * retailFactor).toFixed(2)
    this.suggestedWholesaleTarget.value = (totalWithTaxes * wholesaleFactor).toFixed(2)
  }
}