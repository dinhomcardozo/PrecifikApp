class CreateResalableProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :resalable_products do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.references :category, foreign_key: true
      t.float :profit_margin, default: 0
      t.boolean :custom, default: false
      t.string :custom_type
      t.float :purchase_price, default: 0
      t.references :supplier, foreign_key: true
      t.references :tax, foreign_key: true
      t.timestamps
    end
  end
end
