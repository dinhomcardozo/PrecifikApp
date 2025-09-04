class Channel < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  
  has_many :sales_targets, dependent: :nullify

  CHANNEL_TYPES = %w[
    digital chat televenda whatsapp facebook instagram
    representação ecommerce consultor indicação outro
  ].freeze

  validates :description, presence: true

  validates :channel_type,
            presence: true,
            inclusion: { in: CHANNEL_TYPES }
end