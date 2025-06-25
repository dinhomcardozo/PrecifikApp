class RenameWeightToWeightInGramsOnSubproducts < ActiveRecord::Migration[8.0]
  def change
    rename_column :subproducts, :weight, :weight_in_grams
  end
end
