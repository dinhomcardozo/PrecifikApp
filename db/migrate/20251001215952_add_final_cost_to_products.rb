class AddFinalCostToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :final_cost, :decimal
  end
end
