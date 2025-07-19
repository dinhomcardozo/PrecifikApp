class Channel < ApplicationRecord
      has_many :sales_targets, dependent: :nullify
  has_many :packages, through: :sales_targets

  CHANNEL_TYPES = %w[
    digital chat televenda whatsapp facebook instagram representação
    ecommerce consultor indicação outro
  ].freeze

  validates :description, presence: true
  validates :channel_cost,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :channel_type,
            presence: true,
            inclusion: { in: CHANNEL_TYPES }

  enum channel_type: CHANNEL_TYPES.index_with(&:to_s)
end