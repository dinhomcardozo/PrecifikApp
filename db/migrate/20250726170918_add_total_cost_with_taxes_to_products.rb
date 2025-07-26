class AddTotalCostWithTaxesToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :total_cost_with_taxes, :decimal
  end
end
