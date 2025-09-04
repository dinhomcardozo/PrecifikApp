class AddClientIdToSalesTargets < ActiveRecord::Migration[8.0]
  def change
    add_column :sales_targets, :client_id, :bigint
  end
end
