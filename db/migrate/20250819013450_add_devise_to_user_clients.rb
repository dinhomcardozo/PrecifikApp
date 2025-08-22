class AddDeviseToUserClients < ActiveRecord::Migration[8.0]
  def change
    add_column :user_clients, :email, :string, null: false, default: ""
    add_index  :user_clients, :email, unique: true
  end
end
