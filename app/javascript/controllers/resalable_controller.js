import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fields", "unitField", "cost", "profitMargin", "sellingPrice", "realProfitMargin"]

  connect() {
    console.log("ResalableController conectado!") // debug
  }

  toggle(event) {
    if (event.target.checked) {
      this.fieldsTarget.style.display = ""
      if (this.hasUnitFieldTarget) {
        this.unitFieldTarget.value = "un"
      }
      this.recalculate()
    } else {
      this.fieldsTarget.style.display = "none"
    }
  }

  recalculate() {
    const cost = parseFloat(this.costTarget.value) || 0
    const margin = parseFloat(this.profitMarginTarget.value) || 0

    const sellingPrice = cost + (cost * margin / 100.0)
    this.sellingPriceTarget.value = sellingPrice.toFixed(2)

    const realMargin = sellingPrice > 0 ? ((sellingPrice - cost) / sellingPrice) * 100 : 0
    this.realProfitMarginTarget.value = realMargin.toFixed(2)
  }
}