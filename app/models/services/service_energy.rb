module Services
  class ServiceEnergy < ApplicationRecord
    self.table_name = "service_energies"
    before_validation :calculate_cost
    before_validation :set_client_id

    belongs_to :service,
               class_name:  "Services::Service",
               inverse_of: :service_energies,
               autosave:   true
    belongs_to :energy, class_name: "Services::Energy", optional: true
    belongs_to :client, class_name: "SystemAdmins::Client"

    validates :client_id, presence: true
    before_validation { self.client_id ||= service&.client_id }

    private

    def calculate_cost
      return if hours_per_service.blank? || energy.blank?
      self.cost = hours_per_service.to_f * energy.consume_per_hour.to_f
    end

    def set_client_id
      self.client_id ||= service&.client_id || energy&.client_id
    end
  end
end