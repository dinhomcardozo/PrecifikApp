class CreateServiceEnergies < ActiveRecord::Migration[8.0]
  def change
    create_table :service_energies do |t|
      t.references :service, null: false, foreign_key: true
      t.references :energy, null: false, foreign_key: true
      t.decimal :hours_per_service
      t.decimal :cost

      t.timestamps
    end
  end
end
