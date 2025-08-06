import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.outsideClick = this.outsideClick.bind(this)
  }

  toggle(event) {
    event.stopPropagation()
    const expanded = this.element.classList.toggle("open")
    this.element.querySelector(".dropdown-toggle")
        .setAttribute("aria-expanded", expanded)
    // quando aberto, fica escutando clique fora
    if (expanded) document.addEventListener("click", this.outsideClick)
    else      document.removeEventListener("click", this.outsideClick)
  }

  outsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.element.classList.remove("open")
      this.element.querySelector(".dropdown-toggle")
          .setAttribute("aria-expanded", false)
      document.removeEventListener("click", this.outsideClick)
    }
  }
}