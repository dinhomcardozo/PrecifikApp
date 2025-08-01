class AddProductAndTotalFixedCostToSalesTargets < ActiveRecord::Migration[8.0]
  def change
    add_reference :sales_targets, :product, null: false, foreign_key: true
    add_column    :sales_targets, :total_fixed_cost, :decimal, precision: 10, scale: 2, default: 0.0
    remove_column :sales_targets, :package_id, :integer
  end
end
