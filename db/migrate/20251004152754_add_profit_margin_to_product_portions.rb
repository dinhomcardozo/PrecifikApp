class AddProfitMarginToProductPortions < ActiveRecord::Migration[8.0]
  def change
    add_column :product_portions, :profit_margin, :decimal
  end
end
