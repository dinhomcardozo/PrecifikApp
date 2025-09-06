module Services
  class Service < ApplicationRecord
    self.table_name = "services"
    
    belongs_to :professional

    has_many :service_inputs,
             class_name:  "Services::ServiceInput",
             inverse_of:   :service,
             dependent:    :destroy

    has_many   :service_subproducts, inverse_of: :service, dependent: :destroy
    has_many   :service_products,    inverse_of: :service, dependent: :destroy
    has_many   :service_energies,    inverse_of: :service, dependent: :destroy
    has_many   :service_equipments,  inverse_of: :service, dependent: :destroy

    accepts_nested_attributes_for :service_inputs,      allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :service_subproducts, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :service_products,    allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :service_energies,    allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :service_equipments,  allow_destroy: true, reject_if: :all_blank
    # Atributo “virtual” para entrada no formato DD:HH:MM:SS
    attr_accessor :total_hours_raw,
                  :hourly_rate

    before_validation :parse_total_hours_raw
    before_save       :compute_items_costs, :compute_final_price

    private

    def parse_total_hours_raw
      return if total_hours_raw.blank?
      d, h, m, s = total_hours_raw.split(":").map(&:to_f)
      self.total_hours = d * 24 + h + (m / 60) + (s / 3600)
    end

    def compute_final_price
      base = hourly_rate * total_hours
      self.service_price      = base + base * (tax / 100.0) + base * (profit_margin / 100.0)
      self.final_service_price = base + service_items_cost + base * (profit_margin / 100.0)
    end

    def compute_items_costs
      service_inputs.each      { |si| si.cost = si.quantity_for_service.to_f * si.input.unit_price.to_f }
      service_subproducts.each { |ss| ss.cost = ss.quantity_for_service.to_f * ss.subproduct.unit_price.to_f }
      service_products.each    { |sp| sp.cost = sp.quantity_for_service.to_f * sp.product.unit_price.to_f }
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
  end
end