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
      this.computeBasePrice();
      return;
    }

    fetch(`/clients/services/professionals/${id}.json`, {
        headers: { Accept: "application/json" }
      })
        .then(r => {
          if (!r.ok) throw new Error(`HTTP ${r.status}`);
          return r.json();
        })
        .then(data => {
          if (data && typeof data.hourly_rate !== "undefined") {
            this.hourlyRateTarget.value = data.hourly_rate;
            this.computeBasePrice();
          } else {
            this.hourlyRateTarget.value = "";
            console.warn("JSON sem hourly_rate:", data);
          }
        })
        .catch(err => {
          this.hourlyRateTarget.value = "";
          console.error("Falha no fetch de hourly_rate:", err);
        });
  }

  maskTotalHours(event) {
    let v = event.target.value.replace(/\D/g, ""); // só números
    let parts = [];

    if (v.length > 0) parts.push(v.substring(0, 2)); // DD
    if (v.length > 2) parts.push(v.substring(2, 4)); // HH
    if (v.length > 4) parts.push(v.substring(4, 6)); // MM
    if (v.length > 6) parts.push(v.substring(6, 8)); // SS

    event.target.value = parts.join(":");
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
    this.basePriceTarget.value = labour.toFixed(2);

    if (this.hasItemsCostTarget) {
      this.itemsCostTarget.value = itemsCost.toFixed(2);
    }

    if (this.hasFinalPriceTarget) {
      this.finalPriceTarget.value = (labour + itemsCost).toFixed(2);
    }
  }
}
