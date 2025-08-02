class RemoveSalesTargetSumFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :sales_target_sum, :integer
  end
end
