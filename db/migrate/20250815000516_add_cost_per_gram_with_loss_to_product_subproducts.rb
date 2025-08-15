class AddCostPerGramWithLossToProductSubproducts < ActiveRecord::Migration[8.0]
  def change
    add_column :product_subproducts, :cost_per_gram_with_loss, :decimal
  end
end
