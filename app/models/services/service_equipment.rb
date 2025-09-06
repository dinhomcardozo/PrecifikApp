module Services
  class ServiceEquipment < ApplicationRecord
    self.table_name = "service_equipments"
    before_validation :calculate_cost

    belongs_to :service, class_name: "Services::Service"
    belongs_to :equipment

    private

    def calculate_cost
      return if hours_per_service.blank? || equipment.blank?
      self.cost = hours_per_service.to_f * equipment.depreciation_value.to_f
    end
  end
end