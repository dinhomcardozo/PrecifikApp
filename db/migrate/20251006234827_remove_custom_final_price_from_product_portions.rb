class RemoveCustomFinalPriceFromProductPortions < ActiveRecord::Migration[8.0]
  def change
    remove_column :product_portions, :custom_final_price, :decimal
  end
end
