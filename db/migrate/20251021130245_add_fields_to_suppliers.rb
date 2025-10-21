class AddFieldsToSuppliers < ActiveRecord::Migration[8.0]
  def change
    add_column :suppliers, :cnpj, :string, null: true
    add_column :suppliers, :email, :string
    add_column :suppliers, :phone, :string
    add_column :suppliers, :address, :string
    add_column :suppliers, :number_address, :string
    add_column :suppliers, :city, :string
    add_column :suppliers, :state, :string
  end
end
