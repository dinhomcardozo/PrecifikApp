module SystemAdmins
  class UserAdmin < ApplicationRecord
    self.table_name = 'user_admins'

    devise :database_authenticatable,
           :recoverable, :rememberable, :validatable,
           :confirmable, :lockable, :trackable, :timeoutable

    has_many :user_clients,
             class_name:  "SystemAdmins::UserClient",
             foreign_key: "user_admin_id",
             dependent:   :destroy
  end
end