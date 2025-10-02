class ChangeSalesTargetsToUseProductPortion < ActiveRecord::Migration[8.0]
  def change
    if column_exists?(:sales_targets, :product_id)
      remove_column :sales_targets, :product_id, :bigint
    end

    add_reference :sales_targets, :product_portion, null: true, foreign_key: true
  end
end
