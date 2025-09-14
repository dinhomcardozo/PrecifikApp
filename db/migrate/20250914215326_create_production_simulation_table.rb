class CreateProductionSimulationTable < ActiveRecord::Migration[8.0]
  def change
    create_table :production_simulations do |t|
      t.references :client, null: false, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :user_clients }
      t.references :updated_by, foreign_key: { to_table: :user_clients }

      t.references :product, null: false, foreign_key: true
      t.decimal :quantity_in_grams, precision: 10, scale: 2, null: false

      t.decimal :total_quantity, precision: 10, scale: 2
      t.decimal :total_cost, precision: 12, scale: 2
      t.decimal :minimum_selling_price, precision: 12, scale: 2
      t.decimal :total_selling_price, precision: 12, scale: 2
      t.decimal :total_retail_profit, precision: 12, scale: 2
      t.decimal :total_wholesale_profit, precision: 12, scale: 2

      t.timestamps
    end
  end
end
