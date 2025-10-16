class AddPlanIdToBanners < ActiveRecord::Migration[8.0]
  def change
    add_column :banners, :plan_id, :integer
    add_index  :banners, :plan_id
  end
end
