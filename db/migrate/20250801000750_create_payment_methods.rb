class CreatePaymentMethods < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.string :code
      t.string :fee_type
      t.decimal :fee_value

      t.timestamps
    end
    add_index :payment_methods, :code
  end
end
