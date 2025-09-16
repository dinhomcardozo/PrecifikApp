class AddProductUnitsToProductionSimulations < ActiveRecord::Migration[8.0]
  def change
    add_column :production_simulations, :product_units, :decimal
  end
end
