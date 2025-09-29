import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  connect() {
    this.containerTarget.querySelectorAll(".nested-fields").forEach(wrapper => {
      const select = wrapper.querySelector("select")
      const unitsInput = wrapper.querySelector("input[name*='[package_units]']")
      if (select && unitsInput) {
        this.updateTotal({ target: unitsInput })
      }
    })
  }

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML("beforeend", content)
    this.updateFinalPrice()
  }

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest(".nested-fields")
    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove()
    } else {
      wrapper.style.display = "none"
      wrapper.querySelector("input[name*='_destroy']").value = 1
    }
    this.updateFinalPrice()
  }

  updateTotal(event) {
    const wrapper = event.target.closest(".nested-fields")
    const select = wrapper.querySelector("select")
    const unitsInput = wrapper.querySelector("input[name*='[package_units]']")
    const totalField = wrapper.querySelector(".total-price-field")

    const selectedOption = select.options[select.selectedIndex]
    const unitPrice = parseFloat(selectedOption.dataset.unitPrice || 0)
    const units = parseInt(unitsInput.value || 0)

    const total = unitPrice * units
    totalField.value = total.toFixed(2).replace(".", ",")

    this.updateFinalPrice()
  }

  updateFinalPrice() {
    let total = 0
    this.containerTarget.querySelectorAll(".nested-fields").forEach(wrapper => {
      if (wrapper.style.display !== "none") {
        const input = wrapper.querySelector(".total-price-field")
        if (input && input.value) {
          total += parseFloat(input.value.replace(",", ".")) || 0
        }
      }
    })

    const finalField = document.querySelector("#product_portion_final_package_price")
    if (finalField) {
      finalField.value = total.toFixed(2).replace(".", ",")
    }
  }
}