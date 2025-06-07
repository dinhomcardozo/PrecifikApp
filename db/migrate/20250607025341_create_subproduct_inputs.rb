class CreateSubproductInputs < ActiveRecord::Migration[8.0]
  def change
    create_table :subproduct_inputs do |t|
      t.references :subproduct, null: false, foreign_key: true
      t.references :input, null: false, foreign_key: true
      t.float :quantity

      t.timestamps
    end
  end
end
