class ChangeConsumePerHourToDecimalInEnergies < ActiveRecord::Migration[8.0]
  def up
    change_column :energies,           # <— aqui
                  :consume_per_hour,
                  :decimal,
                  precision: 10,
                  scale: 3
  end

  def down
    change_column :energies,           # <— e aqui
                  :consume_per_hour,
                  :decimal,
                  precision: 10,
                  scale: 2
  end
end
