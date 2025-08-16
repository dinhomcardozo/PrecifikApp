class CreateSystemAdminsUserAdmins < ActiveRecord::Migration[8.0]
  def change
    create_table :system_admins_user_admins do |t|
      t.string :full_name
      t.string :email
      t.string :phone
      t.boolean :admin

      t.timestamps
    end
  end
end
