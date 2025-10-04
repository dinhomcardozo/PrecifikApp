class AddTaxToProductPortions < ActiveRecord::Migration[8.0]
  def change
    add_reference :product_portions, :tax, null: true, foreign_key: true
  end
end
