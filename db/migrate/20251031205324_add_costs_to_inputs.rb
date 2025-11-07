class AddCostsToInputs < ActiveRecord::Migration[8.0]
  def change
    add_column :inputs, :cost_per_gram, :decimal
    add_column :inputs, :cost_per_unit, :decimal
    add_column :inputs, :cost_per_m2, :decimal
  end
end
