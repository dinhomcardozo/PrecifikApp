class CreatePriceListRules < ActiveRecord::Migration[8.0]
  def change
    create_table :price_list_rules do |t|
      t.references :price_list, null: false, foreign_key: true
      t.references :product_portion, null: false, foreign_key: true
      t.references :channel, null: false, foreign_key: true
      t.string :unit_type
      t.decimal :initial_quantity
      t.decimal :final_quantity
      t.string :discount_type
      t.decimal :discount_value
      t.decimal :final_price

      t.timestamps
    end
  end
end
