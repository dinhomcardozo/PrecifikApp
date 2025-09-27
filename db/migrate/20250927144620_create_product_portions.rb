class CreateProductPortions < ActiveRecord::Migration[8.0]
  def change
    create_table :product_portions do |t|
      t.references :product, null: false, foreign_key: true
      t.float :portioned_quantity
      t.float :final_package_price
      t.boolean :active

      t.timestamps
    end
  end
end
