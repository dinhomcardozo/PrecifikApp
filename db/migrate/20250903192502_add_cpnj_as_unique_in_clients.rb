class AddCpnjAsUniqueInClients < ActiveRecord::Migration[8.0]
  def change
    add_index :clients, :cnpj, unique: true
  end
end
