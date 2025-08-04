module Services
  class ServiceEnergy < ApplicationRecord
    self.table_name = "service_energies"

    belongs_to :service, class_name: "Services::Service"
    belongs_to :energy
  end
end