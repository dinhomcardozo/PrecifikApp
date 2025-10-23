import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]

  openModalIfNew(event) {
    if (event.target.value === "new_role") {
      const modal = new bootstrap.Modal(document.getElementById("newRoleModal"))
      modal.show()
      this.selectTarget.value = "" // reseta o select
    }
  }
}