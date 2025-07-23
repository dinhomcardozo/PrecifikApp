class CreateTaxProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :tax_profiles do |t|
      t.string :description
      t.boolean :active

      t.timestamps
    end
  end
end
