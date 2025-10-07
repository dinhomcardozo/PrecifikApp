class Channel < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }

  after_save :update_channel_product_portions, if: :saved_change_to_channel_cost?
  
  has_many :sales_targets, dependent: :nullify
  has_many :channel_product_portions, dependent: :destroy

  CHANNEL_TYPES = %w[
    digital chat televenda whatsapp facebook instagram
    representação ecommerce consultor indicação marketplace outro
  ].freeze

  validates :description, presence: true

  validates :channel_type,
            presence: true,
            inclusion: { in: CHANNEL_TYPES }

  validates :channel_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }

  private

  def update_channel_product_portions
    channel_product_portions.find_each do |cpp|
      cpp.update_columns(effective_final_price: cpp.compute_effective_final_price)
    end
  end
end