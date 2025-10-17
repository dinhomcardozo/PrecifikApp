class CreatePriceListsProductPortions < ActiveRecord::Migration[8.0]
  def change
    create_table :price_lists_product_portions do |t|
      t.references :price_list, null: false, foreign_key: true
      t.references :product_portion, null: false, foreign_key: true

      t.timestamps
    end
  end
end
