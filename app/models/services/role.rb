module Services
    class Role < ApplicationRecord
        self.table_name = 'roles'

        has_many :services, class_name: "Services::Service", foreign_key: :role_id
    end
end