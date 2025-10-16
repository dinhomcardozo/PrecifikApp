import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "taxSelect",
    "icms","ipi","pis_cofins","difal","iss","cbs","ibs",
    "distributedFixedCost","finalPackagePrice",
    "finalCost","finalPrice","realProfitMargin", "margin"
  ]

  static values = {
    baseCost: Number,
    fixedCost: Number,
    margin: Number
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

  recalculate() {
    const cost       = this.baseCostValue || 0
    const fixedCost  = this.fixedCostValue || 0
    const pkgCost    = parseFloat(this.finalPackagePriceTarget?.value) || 0
    const marginPct = parseFloat(this.marginTarget?.value) || this.marginValue || 0

    const rates = [
      this.icmsTarget, this.ipiTarget, this.pis_cofinsTarget,
      this.difalTarget, this.issTarget, this.cbsTarget, this.ibsTarget
    ]

    const sumRatePct = rates.reduce((acc, el) => acc + ((parseFloat(el?.value) || 0) / 100), 0)

    const taxBase = cost + fixedCost
    const taxes   = taxBase * sumRatePct

    const finalCost = cost + fixedCost + pkgCost + taxes
    if (this.hasDistributedFixedCostTarget) {
      this.distributedFixedCostTarget.value = fixedCost.toFixed(2)
    }
    if (this.hasFinalCostTarget) {
      this.finalCostTarget.value = finalCost.toFixed(2)
    }

    const finalPrice = finalCost * (1 + marginPct / 100)
    if (this.hasFinalPriceTarget) {
      this.finalPriceTarget.value = finalPrice.toFixed(2)
    }

    if (this.hasRealProfitMarginTarget) {
      const net = finalPrice - finalCost
      this.realProfitMarginTarget.value = finalPrice > 0
        ? ((net / finalPrice) * 100).toFixed(2)
        : "0.00"
    }
  }
}