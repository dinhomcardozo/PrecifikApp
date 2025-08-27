class RemoveUserClientIdFromClients < ActiveRecord::Migration[8.0]
  def change
    remove_column :clients, :user_client_id
  end
end
