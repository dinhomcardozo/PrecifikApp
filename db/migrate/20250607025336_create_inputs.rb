class CreateInputs < ActiveRecord::Migration[8.0]
  def change
    create_table :inputs do |t|
      t.string :name
      t.decimal :cost
      t.string :unit_of_measurement
      t.string :image
      t.float :weight
      t.references :supplier, null: false, foreign_key: true
      t.references :input_type, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
