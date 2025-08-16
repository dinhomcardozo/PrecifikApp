class CreateSystemAdminsUserClients < ActiveRecord::Migration[8.0]
  def change
    create_table :system_admins_user_clients do |t|
      t.references :user, null: false, foreign_key: { to_table: :system_admins_users }
      t.references :client, null: false, foreign_key: { to_table: :system_admins_clients }

      t.timestamps
    end
  end
end
