class RemoveUserIdFromUserClients < ActiveRecord::Migration[8.0]
  def change
    remove_reference :user_clients, :user, index: true
  end
end
