class CreateSystemAdminsClients < ActiveRecord::Migration[8.0]
  def change
    create_table :system_admins_clients do |t|
      t.string :razao_social
      t.string :company_name
      t.string :cnpj
      t.string :first_name
      t.string :last_name
      t.string :cpf
      t.string :phone
      t.string :address
      t.integer :number_address
      t.references :plan, null: false, foreign_key: { to_table: :system_admins_plans }
      t.date :signup_date
      t.date :first_payment
      t.date :last_payment
      t.datetime :first_login
      t.datetime :last_login

      t.timestamps
    end
  end
end
