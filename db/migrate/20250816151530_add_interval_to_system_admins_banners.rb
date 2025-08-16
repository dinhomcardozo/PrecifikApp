class AddIntervalToSystemAdminsBanners < ActiveRecord::Migration[8.0]
  def change
    add_column :system_admins_banners,
               :interval,
               :integer,
               default: 5000,
               null: false
  end
end
