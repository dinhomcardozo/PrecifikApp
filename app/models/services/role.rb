module Services
  class Role < ApplicationRecord
    self.table_name = 'roles'

    belongs_to :client, class_name: "SystemAdmins::Client"
    has_many :services, class_name: "Services::Service", foreign_key: :role_id

    validates :description, presence: true
    validates :client_id, presence: true
  end
end