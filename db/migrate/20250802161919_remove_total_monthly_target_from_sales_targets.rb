class RemoveTotalMonthlyTargetFromSalesTargets < ActiveRecord::Migration[8.0]
  def change
    remove_column :sales_targets, :total_monthly_target, :integer
  end
end
