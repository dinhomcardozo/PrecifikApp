class AddClientIdToPortionPackages < ActiveRecord::Migration[8.0]
  def change
    add_reference :portion_packages, :client, null: true, foreign_key: true
  end
end
