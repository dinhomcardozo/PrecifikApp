class AddTotalMonthlyTargetToSalesTargets < ActiveRecord::Migration[8.0]
  def change
    add_column :sales_targets, :total_monthly_target, :integer
  end
end
