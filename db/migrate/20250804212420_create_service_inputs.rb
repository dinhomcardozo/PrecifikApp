class CreateServiceInputs < ActiveRecord::Migration[8.0]
  def change
    create_table :service_inputs do |t|
      t.references :service, null: false, foreign_key: true
      t.references :input, null: false, foreign_key: true
      t.decimal :quantity_for_service
      t.decimal :cost

      t.timestamps
    end
  end
end
