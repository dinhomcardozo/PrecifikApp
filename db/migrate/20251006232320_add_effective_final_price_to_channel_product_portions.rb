class AddEffectiveFinalPriceToChannelProductPortions < ActiveRecord::Migration[8.0]
  def change
    add_column :channel_product_portions, :effective_final_price, :decimal
  end
end
