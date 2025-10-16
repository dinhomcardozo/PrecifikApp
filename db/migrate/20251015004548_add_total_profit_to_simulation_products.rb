class AddTotalProfitToSimulationProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :simulation_products, :total_profit, :decimal
  end
end
