class SimulationProduct < ApplicationRecord
  belongs_to :production_simulation
  belongs_to :product_portion
  delegate :product, to: :product_portion

  def product_units
    return 0 if product_portion&.portioned_quantity.blank? || total_quantity.blank?
    (total_quantity / product_portion.portioned_quantity).floor
  end

  def total_profit
    product_portion.net_profit.to_f * product_units
  end
end