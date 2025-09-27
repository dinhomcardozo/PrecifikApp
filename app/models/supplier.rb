class Supplier < ApplicationRecord
    default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
    has_many :inputs
    has_many :packages
end