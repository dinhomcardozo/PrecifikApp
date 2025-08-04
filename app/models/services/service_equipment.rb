module Services
  class ServiceEquipment < ApplicationRecord
    self.table_name = "service_equipments"

    belongs_to :service, class_name: "Services::Service"
    belongs_to :equipment
  end
end