class RemoveRetailFieldsFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :profit_margin_retail, :decimal
    remove_column :products, :total_taxes, :decimal
    remove_column :products, :suggested_price_retail, :decimal
  end
end
