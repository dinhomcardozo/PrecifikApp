class RemoveClientIdFromUserClients < ActiveRecord::Migration[8.0]
  def change
    remove_column :user_clients, :client_id, :integer
  end
end
