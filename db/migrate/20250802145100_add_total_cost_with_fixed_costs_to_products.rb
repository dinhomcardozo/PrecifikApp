class AddTotalCostWithFixedCostsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products,
               :total_cost_with_fixed_costs,
               :decimal,
               default: 0.0,
               null: false
  end
end