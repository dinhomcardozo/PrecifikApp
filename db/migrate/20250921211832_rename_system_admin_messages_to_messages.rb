class RenameSystemAdminMessagesToMessages < ActiveRecord::Migration[8.0]
  def change
    rename_table :system_admins_messages, :messages
  end
end
