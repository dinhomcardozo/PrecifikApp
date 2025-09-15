class AddQuantityWithLossToProductSubproducts < ActiveRecord::Migration[8.0]
  def change
    add_column :product_subproducts, :quantity_with_loss, :float
  end
end
