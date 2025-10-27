class CreateCustomCosts < ActiveRecord::Migration[8.0]
  def change
    create_table :custom_costs do |t|
      t.references :resalable_product, null: false, foreign_key: true
      t.references :input, null: false, foreign_key: true
      t.string :unit_of_measurement
      t.float :weight
      t.float :quantity
      t.float :cost
      t.timestamps
    end
  end
end
