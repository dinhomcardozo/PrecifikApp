// app/javascript/application.js

import "@hotwired/turbo-rails"
import "@rails/activestorage"
import "controllers"

console.log("JavaScript do formulário aninhado carregado.");

let adicionarInsumoJSLoaded = false;

document.addEventListener("turbo:load", function () {
  document.body.addEventListener("click", function (e) {
    if (e.target.classList.contains("add_fields")) {
      e.preventDefault();

      const id = e.target.dataset.id;
      let fields = e.target.dataset.fields;

      fields = fields.replace(/NEW_RECORD/g, new Date().getTime());

      // Captura a tabela pelo ID diretamente
      const container = document.querySelector("#compositions tbody");

      if (!container) {
        console.warn("TBody NÃO encontrado");
        return;
      }

      const tempDiv = document.createElement("div");
      tempDiv.innerHTML = fields;

      const lastRow = container.querySelector("tr:last-child");

      if (lastRow) {
        container.insertBefore(tempDiv.firstChild, lastRow);
      } else {
        container.appendChild(tempDiv.firstChild);
      }
    }

    if (e.target.classList.contains("remove_fields")) {
      const row = e.target.closest("tr");
      if (row) {
        row.remove();
      }
      e.preventDefault();
    }
  });
});