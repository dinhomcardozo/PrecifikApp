class TaxProfileItem < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  belongs_to :tax_profile

  enum :tax_type, {
    recoverable:     "recoverable",
    non_recoverable: "non_recoverable"
  }

  validates :name,  inclusion: {
    in: %w[icms ipi pis_cofins iss difal cbs ibs]
  }
  validates :value, numericality: { greater_than_or_equal_to: 0 }
end