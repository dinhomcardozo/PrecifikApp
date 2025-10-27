class AddResalableProductToInputs < ActiveRecord::Migration[8.0]
  def change
    add_column :inputs, :resalable_product, :boolean, default: false, null: false
  end
end
