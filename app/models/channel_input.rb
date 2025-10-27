# app/models/channel_input.rb
class ChannelInput < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }

  belongs_to :input
  belongs_to :channel

  before_save :update_effective_final_price

  def price_with_commission
    (input.selling_price.to_f * (1 + channel.channel_cost.to_f / 100.0)).round(2)
  end

  def compute_effective_final_price
    commission_price = price_with_commission
    base_price       = corrected_final_price.to_f

    if corrected_final_price.blank? || base_price.zero? || base_price < commission_price
      commission_price
    else
      base_price
    end
  end

  def update_effective_final_price
    self.effective_final_price = compute_effective_final_price
  end

  def final_channel_cost
    (input.final_cost.to_f * (1 + channel.channel_cost.to_f / 100.0)).round(2)
  end

  def corrected_profit_margin
    return nil unless effective_final_price.to_f > 0
    ((effective_final_price - final_channel_cost) / effective_final_price) * 100
  end

  validates :corrected_final_price,
            numericality: { greater_than_or_equal_to: ->(ci) { ci.input.selling_price.to_f } },
            allow_nil: true
end