class AddCaloriesToInputs < ActiveRecord::Migration[8.0]
  def change
    add_column :inputs, :calories, :float, 0
  end
end
