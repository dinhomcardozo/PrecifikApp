class CreatePaymentMethodInstallments < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_method_installments do |t|
      t.references :payment_method, null: false, foreign_key: true
      t.integer :installment_count
      t.decimal :percentage_fee

      t.timestamps
    end
  end
end
