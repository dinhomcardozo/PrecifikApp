class AddTaxTypeToFixedTaxes < ActiveRecord::Migration[8.0]
  def change
    add_column :fixed_taxes, :tax_type, :string, default: "recoverable", null: false
  end
end
