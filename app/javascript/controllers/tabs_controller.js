// app/javascript/controllers/tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = []

  switch(e) {
    e.preventDefault()
    const link = e.currentTarget
    const panelId = link.dataset.tabsPanel

    // 1) marca o tab
    this.element
      .querySelectorAll(".nav-link")
      .forEach(a => a.classList.remove("active"))
    link.classList.add("active")

    // 2) mostra o painel e esconde os outros
    this.element
      .querySelectorAll(".tab-pane")
      .forEach(p => {
        p.id === panelId
          ? p.classList.remove("d-none")
          : p.classList.add("d-none")
      })
  }
}