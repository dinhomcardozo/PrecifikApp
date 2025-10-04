class AddCustomFinalPriceToProductPortions < ActiveRecord::Migration[8.0]
  def change
    add_column :product_portions, :custom_final_price, :decimal, precision: 10, scale: 2
  end
end
