class CreateProductSubproducts < ActiveRecord::Migration[8.0]
  def change
    create_table :product_subproducts do |t|
      t.references :product, null: false, foreign_key: true
      t.references :subproduct, null: false, foreign_key: true
      t.float :quantity

      t.timestamps
    end
  end
end
