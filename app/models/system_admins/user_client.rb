# app/models/system_admins/user_client.rb
module SystemAdmins
  class UserClient < ApplicationRecord
    self.table_name = 'user_clients'
    
    devise :database_authenticatable,
           :registerable,
           :recoverable,
           :rememberable,
           :validatable

    belongs_to :user_admin, optional: true
    has_one :client,
            class_name:  'SystemAdmins::Client',
            foreign_key: 'user_client_id',
            inverse_of:  :user_client,
            dependent:   :destroy

    accepts_nested_attributes_for :client

    delegate :plan, to: :client, allow_nil: true
    delegate :subscription_active?, to: :client, prefix: false, allow_nil: true
    
    validates :email, presence: true, uniqueness: true
  end
end