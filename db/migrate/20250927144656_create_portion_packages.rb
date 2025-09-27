class CreatePortionPackages < ActiveRecord::Migration[8.0]
  def change
    create_table :portion_packages do |t|
      t.references :product_portion, null: false, foreign_key: true
      t.references :package, null: false, foreign_key: true
      t.integer :package_units
      t.float :total_package_price

      t.timestamps
    end
  end
end
