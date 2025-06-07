class CreateSubproducts < ActiveRecord::Migration[8.0]
  def change
    create_table :subproducts do |t|
      t.string :name
      t.float :weight
      t.float :cost
      t.string :unit_of_measurement
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
