class RenameCardCostPctAndBankSlipPctInProducts < ActiveRecord::Migration[8.0]
  def change
    rename_column :products, :card_cost_pct, :card_cost
    rename_column :products, :bank_slip_pct, :bank_slip
  end
end
