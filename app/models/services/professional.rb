module Services
  class Professional < ApplicationRecord
    self.table_name = 'professionals'
    belongs_to :role
    has_many :service_professionals, class_name: "Services::ServiceProfessional"
    has_many :services, through: :service_professionals, class_name: "Services::Service"
  end
end