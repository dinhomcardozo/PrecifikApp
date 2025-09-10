import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "row"]

  connect() {
    this.inputTarget.addEventListener("input", this.filter.bind(this))
  }

  filter() {
    const term = this.inputTarget.value.trim().toLowerCase()
    this.rowTargets.forEach(tr => {
      const text = tr.querySelector("td").textContent.toLowerCase()
      tr.style.display = text.includes(term) ? "" : "none"
    })
  }
}