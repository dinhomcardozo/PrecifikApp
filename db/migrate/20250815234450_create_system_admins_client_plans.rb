class CreateSystemAdminsClientPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :system_admins_client_plans do |t|
      t.references :client, null: false, foreign_key: { to_table: :system_admins_clients }
      t.references :plan, null: false, foreign_key: { to_table: :system_admins_plans }

      t.timestamps
    end
  end
end
