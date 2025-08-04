class CreateEquipment < ActiveRecord::Migration[8.0]
  def change
    create_table :equipment do |t|
      t.string :description
      t.decimal :value
      t.float :depreciation_percent
      t.decimal :depreciation_value

      t.timestamps
    end
  end
end
