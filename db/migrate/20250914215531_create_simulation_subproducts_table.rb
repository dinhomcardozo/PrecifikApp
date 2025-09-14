class CreateSimulationSubproductsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :simulation_subproducts do |t|
      t.references :production_simulation, null: false, foreign_key: true
      t.references :subproduct, null: false, foreign_key: true

      t.decimal :total_quantity, precision: 10, scale: 2
      t.decimal :total_cost, precision: 12, scale: 2

      t.timestamps
    end
  end
end
