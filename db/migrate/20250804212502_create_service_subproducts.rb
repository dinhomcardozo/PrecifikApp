class CreateServiceSubproducts < ActiveRecord::Migration[8.0]
  def change
    create_table :service_subproducts do |t|
      t.references :service, null: false, foreign_key: true
      t.references :subproduct, null: false, foreign_key: true
      t.decimal :quantity_for_service
      t.decimal :cost

      t.timestamps
    end
  end
end
