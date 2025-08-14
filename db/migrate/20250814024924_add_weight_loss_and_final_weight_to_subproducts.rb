class AddWeightLossAndFinalWeightToSubproducts < ActiveRecord::Migration[8.0]
  def change
    add_column :subproducts, :weight_loss, :decimal, default: 0.0
    add_column :subproducts, :final_weight, :decimal, default: 0.0
  end
end
