// app/javascript/controllers/select2_controller.js
import { Controller } from "@hotwired/stimulus"
import $ from "jquery"
window.$ = window.jQuery = $

import "select2"

export default class extends Controller {
  static values = {
    url:                   String,
    placeholder:           String,
    minimumInputLength:    { type: Number, default: 2 }
  }

  connect() {
    $(this.element).select2({ width: "100%" })
  }

  disconnect() {
    if ($(this.element).data("select2")) {
      $(this.element).select2("destroy")
    }
  }

  initializeSelect2() {
    $(this.element).select2({
      ajax: {
        url:        this.urlValue,
        dataType:   "json",
        delay:      250,
        data:       term => ({ q: term.term }),
        processResults: data => ({ results: data }),
        cache:      true
      },
      placeholder:          this.placeholderValue,
      minimumInputLength:   this.minimumInputLengthValue,
      allowClear:           true,
      width:                "100%"
    })
  }

  destroySelect2() {
    if (this.element && $(this.element).data('select2')) {
      $(this.element).select2('destroy')
    }
  }
}