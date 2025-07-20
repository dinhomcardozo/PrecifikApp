class CreatePackages < ActiveRecord::Migration[8.0]
  def change
    create_table :packages do |t|
      t.string     :description
      t.references :brand,   null: false, foreign_key: true
      t.references :channel, null: false, foreign_key: true
      t.float      :total_weight
      t.decimal    :general_discount, precision: 5,  scale: 2
      t.decimal    :subtotal_price,    precision: 10, scale: 2
      t.decimal    :total_price,       precision: 10, scale: 2
      t.decimal    :final_price,       precision: 10, scale: 2

      t.timestamps
    end
  end
end