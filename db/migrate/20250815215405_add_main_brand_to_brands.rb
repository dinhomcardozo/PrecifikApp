class AddMainBrandToBrands < ActiveRecord::Migration[8.0]
  def change
    add_column :brands, :main_brand, :boolean, default: false, null: false
  end
end
