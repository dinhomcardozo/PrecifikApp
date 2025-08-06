import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "professionalSelect",
    "hourlyRate",
    "totalRaw",
    "totalDecimal",
    "tax",
    "profit",
    "basePrice"
  ]

  loadProfessionals(event) {
    const roleId = event.currentTarget.value
    fetch(`/roles/${roleId}/professionals.json`)
      .then(r => r.json())
      .then(data => {
        this.professionalSelectTarget.innerHTML = "<option></option>"
        data.forEach(prof => {
          const opt = document.createElement("option")
          opt.value = prof.id
          opt.textContent = prof.name
          this.professionalSelectTarget.append(opt)
        })
      })
  }

  loadHourlyRate(event) {
    const profId = event.currentTarget.value
    fetch(`/professionals/${profId}.json`)
      .then(r => r.json())
      .then(data => {
        this.hourlyRateTarget.value = data.hourly_rate
        this.computeBasePrice()
      })
  }

  parseTotalHours() {
    const [d, h, m, s] = this.totalRawTarget.value
      .split(":").map(Number)
    if ([d,h,m,s].some(isNaN)) return
    const decimal = d * 24 + h + m / 60 + s / 3600
    this.totalDecimalTarget.value = decimal.toFixed(4)
    this.computeBasePrice()
  }

  computeBasePrice() {
    const rate    = parseFloat(this.hourlyRateTarget.value) || 0
    const hours   = parseFloat(this.totalDecimalTarget.value) || 0
    const taxPerc = parseFloat(this.taxTarget.value) / 100 || 0
    const profPerc= parseFloat(this.profitTarget.value) / 100 || 0

    const base = rate * hours
    const price = base + base * taxPerc + base * profPerc
    this.basePriceTarget.value = price.toFixed(2)
  }
}