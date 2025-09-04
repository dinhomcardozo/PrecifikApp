// app/javascript/controllers/cnpj_verification_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "message"]

  connect() {
    // Apenas para debug
    console.log("CNPJ verification controller conectado")
  }

  maskAndCheck() {
    let value = this.inputTarget.value.replace(/\D/g, "") // só números

    // Máscara de CNPJ
    if (value.length > 2) value = value.replace(/^(\d{2})(\d)/, "$1.$2")
    if (value.length > 6) value = value.replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3")
    if (value.length > 9) value = value.replace(/\.(\d{3})(\d)/, ".$1/$2")
    if (value.length > 13) value = value.replace(/(\d{4})(\d)/, "$1-$2")

    this.inputTarget.value = value

    // Quando tiver 14 dígitos numéricos, faz a verificação
    if (value.replace(/\D/g, "").length === 14) {
      fetch(`/clients/check_cnpj?cnpj=${value.replace(/\D/g, "")}`)
        .then(response => response.json())
        .then(data => {
          if (data.exists) {
            this.messageTarget.textContent = "Ops... CNPJ já existe na base de dados. Digite outro."
            this.messageTarget.style.color = "red"
          } else {
            this.messageTarget.textContent = "Tudo certo. CNPJ único!"
            this.messageTarget.style.color = "green"
          }
        })
    } else {
      this.messageTarget.textContent = ""
    }
  }
}