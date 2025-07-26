class CreateTaxes < ActiveRecord::Migration[8.0]
  def change
    create_table :taxes do |t|
      t.text :description
      t.decimal :icms
      t.decimal :ipi
      t.decimal :pis_cofins
      t.decimal :difal
      t.decimal :iss
      t.decimal :cbs
      t.decimal :ibs
      t.text :note

      t.timestamps
    end
  end
end
