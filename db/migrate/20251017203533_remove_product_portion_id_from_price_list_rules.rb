class RemoveProductPortionIdFromPriceListRules < ActiveRecord::Migration[8.0]
  def change
    remove_column :price_list_rules, :product_portion_id, :integer
  end
end
