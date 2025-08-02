class AddSalesTargetSumToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :sales_target_sum, :integer, default: 0, null: false
  end
end
