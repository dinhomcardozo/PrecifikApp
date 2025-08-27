class AddClientIdToUserClients < ActiveRecord::Migration[8.0]
  def change
    add_reference :user_clients, :client, null: true, foreign_key: true
  end
end
