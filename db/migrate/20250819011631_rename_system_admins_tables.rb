class RenameSystemAdminsTables < ActiveRecord::Migration[8.0]
  def change
    rename_table :system_admins_banners, :banners
    rename_table :system_admins_clients, :clients
    rename_table :system_admins_user_admins, :user_admins
    rename_table :system_admins_user_clients, :user_clients
    rename_table :system_admins_plans, :plans
    rename_table :system_admins_client_plans, :client_plans
  end
end
