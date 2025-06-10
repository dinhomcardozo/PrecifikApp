// app/javascript/application.js

import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", function () {
  document.body.addEventListener("click", function (e) {
    // Adicionar nova linha de composição
    if (e.target.classList.contains("add_fields")) {
      const id = e.target.dataset.id;
      const fields = e.target.dataset.fields.replace(/NEW_RECORD/g, new Date().getTime());
      const container = e.target.closest("table")?.querySelector("tbody");

      if (container) {
        const newElement = document.createElement("div");
        newElement.innerHTML = fields;

        container.insertBefore(newElement.firstChild, container.querySelector("tr:last-child"));
      }

      e.preventDefault();
    }

    // Remover linha de composição
    if (e.target.classList.contains("remove_fields")) {
      const row = e.target.closest("tr");
      if (row) {
        row.remove();
      }
      e.preventDefault();
    }
  });
});