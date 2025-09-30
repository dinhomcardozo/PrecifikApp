class AddClientIdToProductPortions < ActiveRecord::Migration[8.0]
  def change
    add_reference :product_portions, :client, foreign_key: true, null: true
  end
end
