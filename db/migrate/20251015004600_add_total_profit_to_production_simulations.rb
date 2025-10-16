class AddTotalProfitToProductionSimulations < ActiveRecord::Migration[8.0]
  def change
    add_column :production_simulations, :total_profit, :decimal
  end
end
