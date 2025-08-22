class AllowNullClientIdOnUserClients < ActiveRecord::Migration[8.0]
  def change
    change_column_null :user_clients, :client_id, true
  end
end
