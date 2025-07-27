import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "taxSelect",
    "icms","ipi","pis_cofins","difal","iss","cbs","ibs",
    "totalCostWithTaxes","suggestedRetail","suggestedWholesale"
  ]

  static values = {
    baseCost: Number,
    marginRetail: Number,
    marginWholesale: Number
  }

  connect() {
    // popula margens com valores do elemento
    // (eles já vêm dos data-attributes)
    this.fillTaxFields()
    this.recalculate()
  }

  fillTaxFields() {
    const opt = this.taxSelectTarget.selectedOptions[0]
    if (!opt) return

    const tax = JSON.parse(opt.dataset.json || "{}")

    this.icmsTarget.value       = tax.icms.toFixed(2)
    this.ipiTarget.value        = tax.ipi.toFixed(2)
    this.pis_cofinsTarget.value = tax.pis_cofins.toFixed(2)
    this.difalTarget.value      = tax.difal.toFixed(2)
    this.issTarget.value        = tax.iss.toFixed(2)
    this.cbsTarget.value        = tax.cbs.toFixed(2)
    this.ibsTarget.value        = tax.ibs.toFixed(2)
  }

  recalculate() {
    const base = this.baseCostValue || 0

    const sumRates = [
      this.icmsTarget, this.ipiTarget, this.pis_cofinsTarget,
      this.difalTarget, this.issTarget, this.cbsTarget, this.ibsTarget
    ].reduce((sum, el) => sum + ((parseFloat(el.value) || 0) / 100), 0)

    const totalWithTaxes = base * (1 + sumRates)
    this.totalCostWithTaxesTarget.value = totalWithTaxes.toFixed(2)

    const retail = this.marginRetailValue || 0
    const wholesale = this.marginWholesaleValue || 0

    this.suggestedRetailTarget.value    = (totalWithTaxes * (1 + retail/100)).toFixed(2)
    this.suggestedWholesaleTarget.value = (totalWithTaxes * (1 + wholesale/100)).toFixed(2)
  }
}