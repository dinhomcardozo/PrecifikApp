class AddDefaultFlagToTaxProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :tax_profiles, :default, :boolean,
               default: false,
               null:    false
  end
end
