class AddCostFieldsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :sales_channel_cost, :decimal, precision: 8, scale: 2, default: 0.0, null: false
    add_column :products, :commission_cost, :decimal, precision: 8, scale: 2, default: 0.0, null: false
    add_column :products, :freight_cost, :decimal, precision: 8, scale: 2, default: 0.0, null: false
    add_column :products, :storage_cost, :decimal, precision: 8, scale: 2, default: 0.0, null: false
  end
end
