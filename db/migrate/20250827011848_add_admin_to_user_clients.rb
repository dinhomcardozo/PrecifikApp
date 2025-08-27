class AddAdminToUserClients < ActiveRecord::Migration[8.0]
  def change
    add_column :user_clients, :admin, :boolean, default: false
  end
end
