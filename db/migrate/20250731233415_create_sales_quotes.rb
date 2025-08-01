class CreateSalesQuotes < ActiveRecord::Migration[8.0]
  def change
    create_table :sales_quotes do |t|
      t.references :client,
                   null: false,
                   foreign_key: { to_table: :sales_clients }
      t.decimal :channel_cost
      t.decimal :bank_slip_cost
      t.decimal :card_cost
      t.string :status
      t.decimal :total

      t.timestamps
    end
  end
end
