class CreateSystemAdminsUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :system_admins_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.boolean :admin
      t.references :client, null: false, foreign_key: { to_table: :system_admins_clients }
      
      t.timestamps
    end
  end
end
