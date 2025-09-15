import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"

import $ from "jquery"
window.$ = window.jQuery = $

import "select2"
import "select2/dist/css/select2.min.css"

import flatpickr from "flatpickr"
import "flatpickr/dist/flatpickr.min.css"
import { Portuguese } from "flatpickr/dist/l10n/pt.js"
import "bootstrap/dist/css/bootstrap.min.css"
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap

import "./controllers"

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

document.addEventListener("turbo:load", () => {
  const el = document.querySelector("#dashboardCarousel")
  if (el) {
    new bootstrap.Carousel(el)
  }
})