class CreatePriceLists < ActiveRecord::Migration[8.0]
  def change
    create_table :price_lists do |t|
      t.string :description
      t.references :product_portion, null: false, foreign_key: true
      t.string :list_type
      t.boolean :active

      t.timestamps
    end
  end
end
