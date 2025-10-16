class ReplaceProductWithProductPortionInSimulationProducts < ActiveRecord::Migration[8.0]
  def change
    if column_exists?(:simulation_products, :product_id)
      remove_reference :simulation_products, :product, foreign_key: true
    end

    add_reference :simulation_products, :product_portion, foreign_key: true
  end
end
