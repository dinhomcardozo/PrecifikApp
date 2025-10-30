class AddWeightToProductSubproducts < ActiveRecord::Migration[8.0]
  def change
    add_column :product_subproducts, :weight, :decimal
  end
end
