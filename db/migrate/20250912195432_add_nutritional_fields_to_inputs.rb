class AddNutritionalFieldsToInputs < ActiveRecord::Migration[8.0]
  def change
    add_column :inputs, :total_fat, :float, 0
    add_column :inputs, :protein, :float, 0
    add_column :inputs, :carbs, :float, 0
    add_column :inputs, :dietary_fiber, :float, 0
    add_column :inputs, :sugars, :float, 0
    add_column :inputs, :sodium, :float, 0
  end
end
