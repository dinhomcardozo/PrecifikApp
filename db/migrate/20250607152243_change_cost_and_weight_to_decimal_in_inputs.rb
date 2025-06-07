class ChangeCostAndWeightToDecimalInInputs < ActiveRecord::Migration[8.0]
  def change
    change_column :inputs, :cost, :decimal, precision: 10, scale: 2, using: 'cost::numeric(10,2)'
    change_column :inputs, :weight, :decimal, precision: 10, scale: 2, using: 'weight::numeric(10,2)'
  end
end