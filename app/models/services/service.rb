module Services
  class Service < ApplicationRecord
    self.table_name = "services"

    belongs_to :role, optional: true
    belongs_to :professional

    has_many :service_inputs,
             class_name:  "Services::ServiceInput",
             inverse_of:   :service,
             dependent:    :destroy

    has_many   :service_subproducts, inverse_of: :service, dependent: :destroy
    has_many   :service_products,    inverse_of: :service, dependent: :destroy
    has_many   :service_energies,    inverse_of: :service, dependent: :destroy
    has_many   :service_equipments,  inverse_of: :service, dependent: :destroy

    accepts_nested_attributes_for :service_inputs,      allow_destroy: true
    accepts_nested_attributes_for :service_subproducts, allow_destroy: true
    accepts_nested_attributes_for :service_products,    allow_destroy: true
    accepts_nested_attributes_for :service_energies,    allow_destroy: true
    accepts_nested_attributes_for :service_equipments,  allow_destroy: true
    # Atributo “virtual” para entrada no formato DD:HH:MM:SS
    attr_accessor :total_hours_raw,
                  :hourly_rate

    before_validation :parse_total_hours_raw
    before_validation :compute_items_costs_and_final_price
    before_save       :compute_items_costs, :compute_final_price

    def total_hours_raw
      return "" if total_hours.blank?

      days  = (total_hours / 24).floor
      hours = (total_hours % 24).floor
      mins  = ((total_hours * 60) % 60).floor
      secs  = ((total_hours * 3600) % 60).floor

      format("%02d:%02d:%02d:%02d", days, hours, mins, secs)
    end

    private

    def parse_total_hours_raw
      return if total_hours_raw.blank?
      d, h, m, s = total_hours_raw.split(":").map(&:to_f)
      self.total_hours = d * 24 + h + (m / 60) + (s / 3600)
    end

    def compute_final_price
      base        = BigDecimal(hourly_rate.to_s) * BigDecimal(total_hours.to_s)
      items_cost  = BigDecimal(service_items_cost.to_s)
      tax_rate    = BigDecimal(tax.to_s) / 100
      profit_rate = BigDecimal(profit_margin.to_s) / 100

      self.service_price       = base + (base * tax_rate) + (base * profit_rate)
      self.final_service_price = base + items_cost + (base * profit_rate)
    end

    def compute_items_costs
      service_inputs.each      { |si| si.cost = si.quantity_for_service.to_f * si.input.cost_per_gram.to_f }
      service_subproducts.each { |ss| ss.cost = ss.quantity_for_service.to_f * ss.subproduct.cost_per_gram.to_f }
      service_products.each    { |sp| sp.cost = sp.quantity_for_service.to_f * sp.product.cost_per_gram.to_f }
      service_energies.each    { |se| se.cost = se.hours_per_service.to_f * se.energy.consume_per_hour.to_f }
      service_equipments.each  { |se| se.cost = se.hours_per_service.to_f * se.equipment.depreciation_value.to_f }

      self.service_items_cost = [
        service_inputs.sum(&:cost),
        service_subproducts.sum(&:cost),
        service_products.sum(&:cost),
        service_energies.sum(&:cost),
        service_equipments.sum(&:cost)
      ].sum
    end

    def compute_items_costs_and_final_price
      self.service_items_cost =
        service_inputs.sum { |si| si.cost.to_d } +
        service_subproducts.sum { |ss| ss.cost.to_d } +
        service_products.sum { |sp| sp.cost.to_d } +
        service_energies.sum { |se| se.cost.to_d } +
        service_equipments.sum { |se| se.cost.to_d }

      base = hourly_rate.to_d * total_hours.to_d
      self.final_service_price = base + service_items_cost + (base * (profit_margin.to_d / 100))
    end
  end
end