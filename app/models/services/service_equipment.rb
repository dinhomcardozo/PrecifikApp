module Services
  class ServiceEquipment < ApplicationRecord
    self.table_name = "service_equipments"
    before_validation :calculate_cost

    belongs_to :client, class_name: "SystemAdmins::Client"
    validates :client_id, presence: true
    before_validation { self.client_id ||= service&.client_id }

    belongs_to :service,
               class_name:  "Services::Service",
               inverse_of:   :service_equipments,
               autosave:     true,
               touch: true
    belongs_to :equipment, optional: true

    private

    def calculate_cost
      return if hours_per_service.blank? || equipment.blank?
      self.cost = hours_per_service.to_f * equipment.depreciation_value.to_f
    end
  end
end