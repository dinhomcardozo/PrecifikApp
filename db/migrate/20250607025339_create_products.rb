class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.text :description
      t.string :unit_of_measurement
      t.float :tax
      t.float :financial_cost
      t.float :total_weight
      t.float :total_cost
      t.float :profit_margin_retail
      t.float :profit_margin_wholesale
      t.float :sale_price_retail
      t.float :sale_price_wholesale
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
