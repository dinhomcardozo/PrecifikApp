import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "professionalSelect",
    "hourlyRate",
    "totalRaw",
    "totalDecimal",
    "tax",
    "profit",
    "basePrice"
  ];

  // 1) Ao mudar o select de profissionais
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
      .then(data => {
        this.hourlyRateTarget.value = data.hourly_rate;
      })
      .catch(() => {
        this.hourlyRateTarget.value = "";
      });
  }

  // 2) Ao perder o foco no campo bruto de horas
  parseTotalHours() {
    const raw = this.totalRawTarget.value.trim(); 
    // espera DD:HH:MM:SS  
    const parts = raw.split(":").map(v => parseInt(v, 10));
    if (parts.length !== 4 || parts.some(isNaN)) {
      this.totalDecimalTarget.value = "";
      this.computeBasePrice();
      return;
    }

    const [days, hrs, mins, secs] = parts;
    let total = days * 24 + hrs + mins / 60 + secs / 3600;
    total = parseFloat(total.toFixed(2)); // 2 casas decimais

    this.totalDecimalTarget.value = total;
    this.computeBasePrice();
  }

  // 3) Recalcula o preço base com hourlyRate, hours, tax e profit
  computeBasePrice() {
    const hr    = parseFloat(this.hourlyRateTarget.value)   || 0;
    const hrs   = parseFloat(this.totalDecimalTarget.value) || 0;
    const tax   = parseFloat(this.taxTarget.value)          || 0;
    const prof  = parseFloat(this.profitTarget.value)       || 0;

    let price = hr * hrs;
    price *= 1 + tax   / 100;
    price *= 1 + prof  / 100;
    price = price.toFixed(2);

    this.basePriceTarget.value = isNaN(price) ? "" : price;
  }
}