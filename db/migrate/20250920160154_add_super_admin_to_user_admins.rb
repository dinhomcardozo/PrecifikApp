class AddSuperAdminToUserAdmins < ActiveRecord::Migration[8.0]
  def change
    add_column :user_admins, :super_admin, :boolean, default: false, null: false
  end
end
