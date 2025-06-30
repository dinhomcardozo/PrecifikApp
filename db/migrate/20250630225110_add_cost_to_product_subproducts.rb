class AddCostToProductSubproducts < ActiveRecord::Migration[8.0]
  def change
    add_column :product_subproducts, :cost, :decimal
  end
end
