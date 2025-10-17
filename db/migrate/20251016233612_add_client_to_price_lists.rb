class AddClientToPriceLists < ActiveRecord::Migration[8.0]
  def change
    add_reference :price_lists, :client, null: false, foreign_key: true
  end
end
