class CreateProductTaxOverrides < ActiveRecord::Migration[8.0]
  def change
    create_table :product_tax_overrides do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name
      t.decimal :value
      t.string :tax_type

      t.timestamps
    end
  end
end
