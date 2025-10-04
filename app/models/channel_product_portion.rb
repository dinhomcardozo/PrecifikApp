class ChannelProductPortion < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }

  belongs_to :product_portion
  belongs_to :channel

  # preço com comissão (não persistido)
  def final_with_commission
    product_portion.final_with_commission(channel)
  end

  def effective_price
    corrected_final_price.presence || final_with_commission
  end

  # validação: se preencher, deve ser >= final_with_commission
  validates :corrected_final_price,
            numericality: { greater_than_or_equal_to: ->(cpp) { cpp.final_with_commission } },
            allow_nil: true
end