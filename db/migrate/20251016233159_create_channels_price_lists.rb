class CreateChannelsPriceLists < ActiveRecord::Migration[8.0]
  def change
    create_table :channels_price_lists do |t|
      t.references :price_list, null: false, foreign_key: true
      t.references :channel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
