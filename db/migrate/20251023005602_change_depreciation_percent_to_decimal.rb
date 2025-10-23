class ChangeDepreciationPercentToDecimal < ActiveRecord::Migration[8.0]
  def change
    change_column :equipments, :depreciation_percent, :decimal, precision: 6, scale: 4
  end
end
