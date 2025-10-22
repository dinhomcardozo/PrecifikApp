import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]

  connect() {
    this.boundAddBrand = this.addBrand.bind(this)
    window.addEventListener("brand:created", this.boundAddBrand)
  }

  disconnect() {
    window.removeEventListener("brand:created", this.boundAddBrand)
  }

  openModalIfNew(event) {
    if (event.target.value === "new_brand") {
      const modalEl = document.getElementById("newBrandModal")
      const modal = new bootstrap.Modal(modalEl)
      modal.show()
      event.target.value = "" // reseta
    }
  }

  addBrand(event) {
    const { id, name } = event.detail
    const select = this.selectTarget

    // cria option
    const option = document.createElement("option")
    option.value = id
    option.textContent = name
    option.selected = true

    // adiciona ao select
    select.appendChild(option)

    // força seleção
    select.value = id

    // dispara change
    select.dispatchEvent(new Event("change"))

    // devolve foco
    select.focus()
  }
}