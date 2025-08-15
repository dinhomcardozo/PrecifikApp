class EnlargeProductPriceColumns < ActiveRecord::Migration[8.0]
  def change
    change_column :products, :total_cost,                  :decimal, precision: 14, scale: 2
    change_column :products, :total_cost_with_taxes,       :decimal, precision: 14, scale: 2
    change_column :products, :total_cost_with_fixed_costs, :decimal, precision: 14, scale: 2
    change_column :products, :suggested_price_retail,      :decimal, precision: 14, scale: 2
    change_column :products, :suggested_price_wholesale,   :decimal, precision: 14, scale: 2
  end
end
