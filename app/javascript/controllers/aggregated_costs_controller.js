import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "total"];

  updateTotal() {
    const sum = this.inputTargets
      .map(el => parseFloat(el.value) || 0)
      .reduce((a, b) => a + b, 0);
    this.totalTarget.textContent = sum.toFixed(2);
  }
}