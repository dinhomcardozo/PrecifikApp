class AddPricingFieldsToProductPortions < ActiveRecord::Migration[8.0]
  def change
    add_column :product_portions, :cost, :decimal, precision: 12, scale: 2
  end
end
