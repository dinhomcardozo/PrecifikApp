class CreateSystemAdminsPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :system_admins_plans do |t|
      t.string :description
      t.decimal :price
      t.boolean :status

      t.timestamps
    end
  end
end
