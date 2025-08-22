class ReplaceUserAdminIdWithUuid < ActiveRecord::Migration[8.0]
def up
    create_table :tmp_system_admins_user_admins, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string   :full_name
      t.string   :email
      t.string   :phone
      t.boolean  :admin
      t.timestamps null: false
    end

    execute <<-SQL.squish
      INSERT INTO tmp_system_admins_user_admins (
        id,
        full_name, email, phone, admin,
        created_at, updated_at
      )
      SELECT
        gen_random_uuid(),
        full_name, email, phone, admin,
        created_at, updated_at
      FROM system_admins_user_admins;
    SQL

    drop_table :system_admins_user_admins
    rename_table :tmp_system_admins_user_admins, :system_admins_user_admins
  end

  def down
    create_table :tmp_system_admins_user_admins, id: :bigserial do |t|
      t.string   :full_name
      t.string   :email
      t.string   :phone
      t.boolean  :admin
      t.timestamps null: false
    end

    execute <<-SQL.squish
      INSERT INTO tmp_system_admins_user_admins (
        full_name, email, phone, admin,
        created_at, updated_at
      )
      SELECT
        full_name, email, phone, admin,
        created_at, updated_at
      FROM system_admins_user_admins;
    SQL

    drop_table :system_admins_user_admins
    rename_table :tmp_system_admins_user_admins, :system_admins_user_admins
  end
end
