class AddFinalCostAndFinalPriceToProductPortions < ActiveRecord::Migration[8.0]
  def change
    add_column :product_portions, :final_cost, :decimal
    add_column :product_portions, :final_price, :decimal
  end
end
