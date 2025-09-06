module Services
  class ServiceEnergy < ApplicationRecord
    self.table_name = "service_energies"
    before_validation :calculate_cost

    belongs_to :service, class_name: "Services::Service"
    belongs_to :energy

    private

    def calculate_cost
      return if hours_per_service.blank? || energy.blank?
      self.cost = hours_per_service.to_f * energy.consume_per_hour.to_f
    end
  end
end