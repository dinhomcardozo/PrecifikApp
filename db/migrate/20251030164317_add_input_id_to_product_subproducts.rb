class AddInputIdToProductSubproducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :product_subproducts, :input, null: true, foreign_key: true
  end
end
