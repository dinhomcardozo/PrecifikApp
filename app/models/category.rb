class Category < ApplicationRecord
  has_many :products, dependent: :nullify

  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
end