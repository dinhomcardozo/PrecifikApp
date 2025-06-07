// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", function () {
  document.body.addEventListener("click", function (e) {
    if (e.target.classList.contains("add_fields")) {
      const id = e.target.dataset.id;
      const fields = e.target.dataset.fields.replace(/NEW_RECORD/g, new Date().getTime());
      const container = e.target.closest(".fields_container") || e.target.parentNode;
      const newElement = document.createElement("div");
      newElement.innerHTML = fields;
      container.appendChild(newElement.firstChild);
      e.preventDefault();
    }
  });
});