class CreateSubproductCompositions < ActiveRecord::Migration[8.0]
  def change
    create_table :subproduct_compositions do |t|
      t.references :subproduct, null: false, foreign_key: true
      t.references :input, null: false, foreign_key: true
      t.float :quantity_for_a_unit

      t.timestamps
    end
  end
end
