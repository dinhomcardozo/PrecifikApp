module Services
  class ServiceProfessional < ApplicationRecord
    self.table_name = 'service_professionals'
    belongs_to :service
    belongs_to :professional

    belongs_to :client, class_name: "SystemAdmins::Client"
    validates :client_id, presence: true
    before_validation { self.client_id ||= service&.client_id }
  end
end