class RemoveWholesaleAndTaxFieldsFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :profit_margin_wholesale, :decimal
    remove_column :products, :tax_id, :integer
    remove_column :products, :suggested_price_wholesale, :decimal
    remove_column :products, :total_cost_with_taxes, :decimal
    remove_column :products, :fixed_cost, :decimal
    remove_column :products, :total_cost_with_fixed_costs, :decimal
  end
end
