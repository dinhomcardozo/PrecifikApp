import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => this.close(), 4000)
  }

  close() {
    this.element.style.transition = "transform 0.5s ease, opacity 0.5s ease"
    this.element.style.transform = "translateY(100%)"
    this.element.style.opacity = "0"
    setTimeout(() => this.element.remove(), 500)
  }
}