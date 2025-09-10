import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { Portuguese } from "flatpickr/dist/l10n/pt.js"

// Conecta Stimulus ao controller
export default class extends Controller {
  static targets = ["start", "end"]

  connect() {
    // Configuração padrão do calendário
    const options = {
      dateFormat: "d/m/Y",
      locale: Portuguese,
      allowInput: true,
      inline: false // garante que não fique fixo na tela
    }

    // Inicializa o calendário para cada campo
    if (this.hasStartTarget) {
      flatpickr(this.startTarget, options)
    }
    if (this.hasEndTarget) {
      flatpickr(this.endTarget, options)
    }
  }
}