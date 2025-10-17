class RemoveProductPortionIdFromPriceLists < ActiveRecord::Migration[8.0]
  def change
    remove_column :price_lists, :product_portion_id, :integer
  end
end
