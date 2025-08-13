import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "professionalSelect",
    "hourlyRate",
    "totalRaw",
    "totalDecimal",
    "tax",
    "profit",
    "basePrice",
    "itemsCost", 
    "finalPrice"
  ];

  connect() {
    this.element.addEventListener("nested-costs-changed", () => this.computeBasePrice());
  }

  loadHourlyRate() {
    const id = this.professionalSelectTarget.value;
    if (!id) {
      this.hourlyRateTarget.value = "";
      return;
    }

    fetch(`/services/professionals/${id}.json`, {
      headers: { Accept: "application/json" }
    })
      .then(r => r.json())
      .then(data => { this.hourlyRateTarget.value = data.hourly_rate; })
      .catch(() => { this.hourlyRateTarget.value = ""; });
  }

  parseTotalHours() {
    const raw   = this.totalRawTarget.value.trim();
    const parts = raw.split(":").map(v => parseInt(v, 10));

    if (parts.length !== 4 || parts.some(isNaN)) {
      this.totalDecimalTarget.value = "";
      this.computeBasePrice();
      return;
    }

    const [days, hrs, mins, secs] = parts;
    let total = days * 24 + hrs + mins / 60 + secs / 3600;
    this.totalDecimalTarget.value = parseFloat(total.toFixed(2));
    this.computeBasePrice();
  }

  computeBasePrice() {
    const hr    = parseFloat(this.hourlyRateTarget.value)   || 0;
    const hrs   = parseFloat(this.totalDecimalTarget.value) || 0;
    const tax   = parseFloat(this.taxTarget.value)          || 0;
    const prof  = parseFloat(this.profitTarget.value)       || 0;

    // Cálculo da mão de obra
    const labour = hr * hrs * (1 + tax/100) * (1 + prof/100);

    // Soma de todos os costs dos nested forms
    const itemsCost = Array.from(
      this.element.querySelectorAll("[data-service-nested-form-target='cost']")
    ).reduce((sum, el) => sum + (parseFloat(el.value) || 0), 0);

    // Atualiza campos
    this.basePriceTarget.value  = labour.toFixed(2);
    this.itemsCostTarget.value  = itemsCost.toFixed(2);
    this.finalPriceTarget.value = (labour + itemsCost).toFixed(2);
  }
}
