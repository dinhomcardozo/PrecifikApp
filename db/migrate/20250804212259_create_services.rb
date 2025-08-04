class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.string :description
      t.references :role, null: false, foreign_key: true
      t.integer :total_seconds
      t.float :tax_percent
      t.float :profit_margin_percent
      t.decimal :final_price

      t.timestamps
    end
  end
end
