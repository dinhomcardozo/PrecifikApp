module Services
  class ServiceProfessional < ApplicationRecord
    self.table_name = 'service_professionals'
    belongs_to :service
    belongs_to :professional
  end
end