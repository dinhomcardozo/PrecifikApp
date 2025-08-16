class CreateSystemAdminsBanners < ActiveRecord::Migration[8.0]
  def change
    create_table :system_admins_banners do |t|
      t.string :image
      t.string :link
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
