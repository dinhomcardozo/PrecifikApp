class RemoveWrongColumnsFromUserClients < ActiveRecord::Migration[8.0]
  def change
    remove_column :user_clients, :default, :boolean
    remove_column :user_clients, :false, :boolean
  end
end
