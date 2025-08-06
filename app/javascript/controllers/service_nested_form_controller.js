import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values  = { association: String }
  static targets = ["items", "template", "item"]

  add(event) {
    event.preventDefault()

    // gera índice único e injeta HTML do template
    const newId   = new Date().getTime()
    const pattern = new RegExp("NEW_" + this.associationValue, "g")
    const content = this.templateTarget.innerHTML.replace(pattern, newId)

    this.itemsTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    event.preventDefault()

    // marca para remoção e oculta o bloco
    const wrapper = event.currentTarget.closest("[data-service-nested-form-target='item']")
    wrapper.querySelector("input.destroy-flag").value = "1"
    wrapper.style.display = "none"
  }
}