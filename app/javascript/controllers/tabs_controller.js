import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link", "panel", "hidden"]

  connect() {
    if (!this.hasHiddenTarget) return
    this.showTab(this.hiddenTarget.value)
    const active = this.hiddenTarget.value
    this.showTab(active)
  }

  switch(event) {
    event.preventDefault()
    const name = event.currentTarget.dataset.tabsPanel.replace("panel-", "")
    this.hiddenTarget.value = name
    this.showTab(name)
  }
  
  showTab(name) {
    this.linkTargets.forEach(link => {
      const linkName = link.dataset.tabsPanel.replace("panel-", "")
      link.classList.toggle("active", linkName === name)
    })
    this.panelTargets.forEach(panel => {
      panel.id === `panel-${name}`
        ? panel.classList.remove("d-none")
        : panel.classList.add("d-none")
    })
  }
  
}

// expose globally
window.TabsController = Controller