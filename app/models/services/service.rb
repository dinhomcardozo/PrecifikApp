module Services
  class Service < ApplicationRecord
    self.table_name = "services"

    belongs_to :client, class_name: "SystemAdmins::Client"
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

    validates :description, presence: true
    validates :professional_id, presence: true
    validates :hourly_rate, presence: true
    validates :total_hours_raw, presence: true
    validates :total_hours, presence: true
    validates :service_price, presence: true
    validates :final_service_price, presence: true
    validates :client_id, presence: true

    accepts_nested_attributes_for :service_inputs,
                                  allow_destroy: true,
                                  reject_if: proc { |attrs| attrs['input_id'].blank? }
    accepts_nested_attributes_for :service_subproducts, allow_destroy: true
    accepts_nested_attributes_for :service_products,    allow_destroy: true
    accepts_nested_attributes_for :service_energies,    allow_destroy: true
    accepts_nested_attributes_for :service_equipments,  allow_destroy: true
    # Atributo “virtual” para entrada no formato DD:HH:MM:SS
    attr_accessor :total_hours_raw,
                  :hourly_rate

    before_validation :parse_total_hours_raw
    before_validation :compute_items_costs_and_final_price

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

   
    def compute_items_costs
      service_inputs.each do |si|
        next if si.input.nil?
        si.cost = si.quantity_for_service.to_f * si.input.cost_per_gram.to_f
      end

      service_subproducts.each do |ss|
        next if ss.subproduct.nil?
        ss.cost = ss.quantity_for_service.to_f * ss.subproduct.cost_per_gram.to_f
      end

      service_products.each do |sp|
        next if sp.product.nil?
        sp.cost = sp.quantity_for_service.to_f * sp.product.cost_per_gram.to_f
      end

      service_energies.each do |se|
        next if se.energy.nil?
        se.cost = se.hours_per_service.to_f * se.energy.consume_per_hour.to_f
      end

      service_equipments.each do |eq|
        next if eq.equipment.nil?
        eq.cost = eq.hours_per_service.to_f * eq.equipment.consume_per_hour.to_f if eq.equipment.respond_to?(:consume_per_hour)
      end

      self.service_items_cost = [
        service_inputs.sum { |i| i.cost.to_f },
        service_subproducts.sum { |s| s.cost.to_f },
        service_products.sum { |p| p.cost.to_f },
        service_energies.sum { |e| e.cost.to_f },
        service_equipments.sum { |eq| eq.cost.to_f }
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

    alias_method :compute_final_price, :compute_items_costs_and_final_price
  end
end