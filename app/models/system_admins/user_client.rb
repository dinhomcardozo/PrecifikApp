# app/models/system_admins/user_client.rb
module SystemAdmins
  class UserClient < ApplicationRecord
    self.table_name = 'user_clients'
    
    belongs_to :client, class_name: 'SystemAdmins::Client', foreign_key: :client_id, optional: true
    
    devise :database_authenticatable,
           :registerable,
           :recoverable,
           :rememberable,
           :validatable

    belongs_to :user_admin, optional: true

    accepts_nested_attributes_for :client

    delegate :plan, to: :client, allow_nil: true
    delegate :subscription_active?, to: :client, prefix: false, allow_nil: true
    
    validates :email, presence: true, uniqueness: true
    validates :first_name, :last_name, presence: true
  end
end