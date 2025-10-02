class AddFixedCostToProductPortions < ActiveRecord::Migration[8.0]
  def change
    add_column :product_portions, :fixed_cost, :decimal, precision: 10, scale: 2
  end
end
