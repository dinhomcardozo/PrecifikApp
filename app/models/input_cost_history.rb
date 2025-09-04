class InputCostHistory < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  
  belongs_to :input

  validates :cost, :recorded_at, presence: true
end
