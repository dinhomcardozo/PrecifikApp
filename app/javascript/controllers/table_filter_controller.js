import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { targetSelector: String }

  connect() {
    this.input = document.getElementById(this.targetSelectorValue)
    this.rows  = Array.from(this.element.querySelectorAll("tbody tr"))
    this.input.addEventListener("input", this.filter.bind(this))
  }

  filter() {
    const term = this.input.value.trim().toLowerCase()
    this.rows.forEach(tr => {
      const text = tr.querySelector("td").textContent.toLowerCase()
      tr.style.display = text.includes(term) ? "" : "none"
    })
  }
}