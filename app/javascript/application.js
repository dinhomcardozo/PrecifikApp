// app/javascript/application.js
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "./controllers"
import $ from "jquery"
import "select2"
import "select2/dist/css/select2.min.css"
import flatpickr from "flatpickr"
import "flatpickr/dist/flatpickr.min.css"
import { Portuguese } from "flatpickr/dist/l10n/pt.js"
import "bootstrap/dist/css/bootstrap.min.css"
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap
window.$ = $
window.jQuery = $

ActiveStorage.start()

document.addEventListener("turbo:load", () => {
  flatpickr(".datepicker", {
    locale: Portuguese,
    dateFormat: "d/m/Y",
    allowInput: true
  })
})

document.addEventListener("turbo:load", () => {
  const el = document.querySelector("#dashboardCarousel")
  if (el) {
    new bootstrap.Carousel(el)
  }
})