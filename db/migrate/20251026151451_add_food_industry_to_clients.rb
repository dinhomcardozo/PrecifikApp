class AddFoodIndustryToClients < ActiveRecord::Migration[8.0]
  def change
    add_column :clients, :food_industry, :boolean, default: false, null: false
  end
end
