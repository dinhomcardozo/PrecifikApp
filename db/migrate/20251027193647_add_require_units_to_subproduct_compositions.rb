class AddRequireUnitsToSubproductCompositions < ActiveRecord::Migration[8.0]
  def change
    add_column :subproduct_compositions, :require_units, :decimal, precision: 10, scale: 2, default: 0
  end
end
