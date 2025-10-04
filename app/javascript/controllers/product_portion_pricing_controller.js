import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "taxSelect",
    "icms","ipi","pis_cofins","difal","iss","cbs","ibs",
    "distributedFixedCost","finalPackagePrice",
    "finalCost","suggestedRetail","realProfitRetailMargin"
  ]

  static values = {
    baseCost: Number,   // product.total_cost
    fixedCost: Number,  // custo fixo total (distributed)
    marginRetail: Number
  }

  connect() {
    this.fillTaxFields()
    this.recalculate()
  }

  // Preenche os campos de alíquotas a partir do dataset JSON do <select>
  fillTaxFields() {
    const opt  = this.taxSelectTarget.selectedOptions[0]
    if (!opt) return
    const tax  = JSON.parse(opt.dataset.json || "{}")

    const format = val => {
      const n = parseFloat(val)
      return isNaN(n) ? "0.00" : n.toFixed(2)
    }

    this.icmsTarget.value       = format(tax.icms)
    this.ipiTarget.value        = format(tax.ipi)
    this.pis_cofinsTarget.value = format(tax.pis_cofins)
    this.difalTarget.value      = format(tax.difal)
    this.issTarget.value        = format(tax.iss)
    this.cbsTarget.value        = format(tax.cbs)
    this.ibsTarget.value        = format(tax.ibs)
  }

  // Recalcula todos os valores derivados
  recalculate() {
    const baseCost   = this.baseCostValue    || 0
    const fixedCost  = this.fixedCostValue   || 0
    const packageCost = parseFloat(this.finalPackagePriceTarget.value) || 0

    const rates = [
      this.icmsTarget, this.ipiTarget, this.pis_cofinsTarget,
      this.difalTarget, this.issTarget, this.cbsTarget, this.ibsTarget
    ]

    // soma dos percentuais (ex: 0.18 para 18%)
    const sumRates = rates.reduce((acc, el) => {
      return acc + ((parseFloat(el.value) || 0) / 100)
    }, 0)

    // 1) Custo fixo distribuído
    this.distributedFixedCostTarget.value = fixedCost.toFixed(2)

    // 2) Total com tributos
    const totalWithTaxes = (baseCost + fixedCost) * (1 + sumRates)

    // 3) Final cost = base + fixo + impostos + embalagens
    const finalCost = totalWithTaxes + packageCost
    this.finalCostTarget.value = finalCost.toFixed(2)

    // 4) Preço sugerido varejo
    const retailFactor = 1 + (this.marginRetailValue || 0) / 100
    this.suggestedRetailTarget.value = (finalCost * retailFactor).toFixed(2)

    // 5) Margem real varejo
    const retail = parseFloat(this.suggestedRetailTarget.value) || 0
    if (retail > 0) {
      this.realProfitRetailMarginTarget.value = (((retail - finalCost) / retail) * 100).toFixed(2)
    }
  }
}