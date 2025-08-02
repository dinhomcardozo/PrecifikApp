class RemoveChannelFromSalesTargets < ActiveRecord::Migration[8.0]
  def change
    remove_reference :sales_targets, :channel, foreign_key: true
  end
end
