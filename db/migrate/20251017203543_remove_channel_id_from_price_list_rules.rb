class RemoveChannelIdFromPriceListRules < ActiveRecord::Migration[8.0]
  def change
    remove_column :price_list_rules, :channel_id, :integer
  end
end
