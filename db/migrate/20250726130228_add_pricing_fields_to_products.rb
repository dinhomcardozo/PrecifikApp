class AddPricingFieldsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :total_taxes, :decimal
  end
end
