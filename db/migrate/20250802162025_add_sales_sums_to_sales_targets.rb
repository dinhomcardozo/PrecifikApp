class AddSalesSumsToSalesTargets < ActiveRecord::Migration[8.0]
  def change
    add_column :sales_targets,
               :sales_target_sum,
               :integer,
               default: 0,
               null: false

    add_column :sales_targets,
               :sales_target_active_sum,
               :integer,
               default: 0,
               null: false
  end
end
