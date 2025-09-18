class SimulationProduct < ApplicationRecord
  belongs_to :production_simulation
  belongs_to :product

  def product_units
    return 0 if product&.final_weight.blank? || total_quantity.blank?
    (total_quantity / product.final_weight).floor
  end
end