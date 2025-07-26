class AddTaxToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :tax, foreign_key: true, null: true
  end
end
