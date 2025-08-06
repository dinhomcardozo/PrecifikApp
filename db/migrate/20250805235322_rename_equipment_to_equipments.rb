class RenameEquipmentToEquipments < ActiveRecord::Migration[8.0]
  def change
    rename_table :equipment, :equipments
  end
end
