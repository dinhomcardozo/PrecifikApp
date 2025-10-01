class AddFixedCostToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :fixed_cost, :decimal
  end
end
