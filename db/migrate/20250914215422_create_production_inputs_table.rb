class CreateProductionInputsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :simulation_inputs do |t|
      t.references :production_simulation, null: false, foreign_key: true
      t.references :input, null: false, foreign_key: true

      t.decimal :total_quantity, precision: 10, scale: 2
      t.decimal :total_cost, precision: 12, scale: 2
      t.decimal :required_units, precision: 10, scale: 2

      t.timestamps
    end
  end
end
