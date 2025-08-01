class CreateSalesClients < ActiveRecord::Migration[8.0]
  def change
    create_table :sales_clients do |t|
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :cnpj
      t.string :phone
      t.string :email
      t.string :address
      t.string :number_address
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
