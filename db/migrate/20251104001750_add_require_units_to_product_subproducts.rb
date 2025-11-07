class AddRequireUnitsToProductSubproducts < ActiveRecord::Migration[8.0]
  def change
    add_column :product_subproducts, :require_units, :decimal
  end
end
