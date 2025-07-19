class CreatePackageCompositions < ActiveRecord::Migration[8.0]
  def change
    create_table :package_compositions do |t|
      t.references :package, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.float :weight
      t.decimal :discount
      t.decimal :price
      t.decimal :subprice

      t.timestamps
    end
  end
end
