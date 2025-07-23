import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["defaults", "customs"];

  toggle(event) {
    const useDefault = event.currentTarget.checked;
    this.defaultsTarget.classList.toggle("d-none", !useDefault);
    this.customsTarget.classList.toggle("d-none", useDefault);
  }
}