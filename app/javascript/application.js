// app/javascript/application.js
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "./controllers"
import flatpickr from "flatpickr"
import "flatpickr/dist/flatpickr.min.css"
import { Portuguese } from "flatpickr/dist/l10n/pt.js"

ActiveStorage.start()

document.addEventListener("turbo:load", () => {
  flatpickr(".datepicker", {
    locale: Portuguese,
    dateFormat: "d/m/Y",
    allowInput: true
  })
})