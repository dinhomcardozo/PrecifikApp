class ChannelProductPorti < ActiveRecord::Migration[8.0]
  def change
    create_table :channel_product_portions do |t|
      t.bigint   :client_id, null: false
      t.bigint   :product_portion_id, null: false
      t.bigint   :channel_id, null: false
      t.decimal  :corrected_final_price, precision: 12, scale: 2 # opcional

      t.timestamps
    end

    add_index :channel_product_portions, [:client_id, :product_portion_id, :channel_id], unique: true, name: "idx_cpp_unique"
    add_foreign_key :channel_product_portions, :product_portions
    add_foreign_key :channel_product_portions, :channels
  end
end