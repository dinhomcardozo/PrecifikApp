class CreateSalesOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :sales_orders do |t|
      t.references :sales_quote, null: false, foreign_key: true
      t.string :status
      t.datetime :placed_at
      t.decimal :total

      t.timestamps
    end
  end
end
