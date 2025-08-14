class AddWeightLossAndFinalWeightToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :weight_loss, :decimal, default: 0.0
    add_column :products, :final_weight, :decimal, default: 0.0
  end
end
