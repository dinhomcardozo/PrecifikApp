// app/javascript/controllers/tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    // primeiro carregamento da aba ativa
    this.loadPanel(this.tabTargets.find(t=>t.classList.contains("active")))
  }

  switch(e) {
    e.preventDefault()
    const btn   = e.currentTarget
    const panel = this.panelTargets.find(p=>p.id === btn.dataset.tabsPanel.slice(1))

    // troca active nos botões
    this.tabTargets.forEach(t => t.classList.remove("active"))
    btn.classList.add("active")

    // esconde todos os painéis
    this.panelTargets.forEach(p => p.classList.remove("show","active"))
    
    // carrega e exibe o painel clicado
    this.loadPanel(btn).then(() => {
      panel.classList.add("show","active")
    })
  }

  async loadPanel(btn) {
    const selector = btn.dataset.tabsPanel
    const panel    = this.element.querySelector(selector)

    // se já tiver conteúdo, não busca de novo
    if (panel.innerHTML.trim() !== "") return

    const url = btn.dataset.tabsUrl
    const html = await fetch(url, { headers: { Accept: "text/vnd.turbo-stream.html" } })
                     .then(r => r.text())
    panel.innerHTML = html
  }
}
