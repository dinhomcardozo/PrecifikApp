class AddSignupDateToUserClients < ActiveRecord::Migration[8.0]
  def change
    add_column :user_clients, :signup_date, :date
  end
end
