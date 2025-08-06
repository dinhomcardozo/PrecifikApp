// app/javascript/controllers/depreciation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["value", "percent", "result"]

  update() {
    const val  = parseFloat(this.valueTarget.value)   || 0
    const pct  = parseFloat(this.percentTarget.value) || 0
    const calc = (val * (pct / 100)).toFixed(2)

    this.resultTarget.value = calc
  }
}