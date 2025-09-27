class CreatePackages < ActiveRecord::Migration[8.0]
  def change
    create_table :packages do |t|
      t.string :description
      t.references :supplier, null: false, foreign_key: true
      t.float :unit_price

      t.timestamps
    end
  end
end
