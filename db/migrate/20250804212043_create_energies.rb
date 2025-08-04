class CreateEnergies < ActiveRecord::Migration[8.0]
  def change
    create_table :energies do |t|
      t.string :description
      t.decimal :consume_per_hour

      t.timestamps
    end
  end
end
