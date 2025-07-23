class AddUseDefaultTaxesToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :use_default_taxes, :boolean, default: true, null: false
  end
end
