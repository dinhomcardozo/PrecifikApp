import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rulesContainer"]

  addRule(event) {
    event.preventDefault()
    const template = document.querySelector("#rule-template").innerHTML
    const newId = new Date().getTime()
    const content = template.replace(/NEW_RECORD/g, newId)
    this.rulesContainerTarget.insertAdjacentHTML("beforeend", content)
  }

  removeRule(event) {
    event.preventDefault()
    const wrapper = event.target.closest(".rule-fields")
    if (wrapper) wrapper.remove()
    this.validateIntervals() // revalida após remover
  }

  validateIntervals() {
    const rules = Array.from(this.rulesContainerTarget.querySelectorAll(".rule-fields"))
    const intervals = []

    // coleta todos os intervalos
    rules.forEach(rule => {
      const initial = parseInt(rule.querySelector("[name*='[initial_quantity]']").value, 10)
      const final   = parseInt(rule.querySelector("[name*='[final_quantity]']").value, 10)

      if (!isNaN(initial) && !isNaN(final)) {
        intervals.push({ initial, final, rule })
      }
    })

    // limpa erros anteriores
    rules.forEach(rule => rule.classList.remove("has-error"))

    // verifica sobreposição
    for (let i = 0; i < intervals.length; i++) {
      for (let j = i + 1; j < intervals.length; j++) {
        const a = intervals[i]
        const b = intervals[j]

        // sobreposição se os ranges se tocam ou cruzam
        if (!(a.final < b.initial || b.final < a.initial)) {
          a.rule.classList.add("has-error")
          b.rule.classList.add("has-error")
        }
      }
    }
  }
}