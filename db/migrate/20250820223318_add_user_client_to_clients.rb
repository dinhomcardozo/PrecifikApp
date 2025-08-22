class AddUserClientToClients < ActiveRecord::Migration[8.0]
  def change
    add_reference :clients,
                  :user_client,
                  foreign_key: true,
                  null: true
  end
end
