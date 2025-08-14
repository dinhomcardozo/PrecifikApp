class AddCategoryToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :category, null: true, foreign_key: true
  end
end
