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
    // valores iniciais das margens
    this.marginRetailValue     = parseFloat(this.element.dataset.marginRetail)     || 0
    this.marginWholesaleValue  = parseFloat(this.element.dataset.marginWholesale)  || 0

    this.fillTaxFields()
    this.recalculate()
  }

  fillTaxFields() {
    const json  = this.taxSelectTarget.selectedOptions[0]?.dataset.json || '{}'
    const tax   = JSON.parse(json)

    this.icmsTarget.value       = (tax.icms     * 100).toFixed(2)
    this.ipiTarget.value        = (tax.ipi      * 100).toFixed(2)
    this.pis_cofinsTarget.value = (tax.pis_cofins* 100).toFixed(2)
    this.difalTarget.value      = (tax.difal    * 100).toFixed(2)
    this.issTarget.value        = (tax.iss      * 100).toFixed(2)
    this.cbsTarget.value        = (tax.cbs      * 100).toFixed(2)
    this.ibsTarget.value        = (tax.ibs      * 100).toFixed(2)
  }

  recalculate() {
    const rates = [
      this.icmsTarget, this.ipiTarget, this.pis_cofinsTarget,
      this.difalTarget, this.issTarget, this.cbsTarget, this.ibsTarget
    ].map(i => (parseFloat(i.value) || 0) / 100)

    const totalTaxFactor    = 1 + rates.reduce((sum, r) => sum + r, 0)
    const costWithTaxes     = this.baseCostValue * totalTaxFactor

    this.totalCostWithTaxesTarget.value = costWithTaxes.toFixed(2)
    this.suggestedRetailTarget.value    =
      (costWithTaxes * (1 + this.marginRetailValue / 100)).toFixed(2)
    this.suggestedWholesaleTarget.value =
      (costWithTaxes * (1 + this.marginWholesaleValue / 100)).toFixed(2)
  }
}