class CreateServiceProfessionals < ActiveRecord::Migration[8.0]
  def change
    create_table :service_professionals do |t|
      t.references :service, null: false, foreign_key: true
      t.references :professional, null: false, foreign_key: true
      t.decimal :hourly_rate

      t.timestamps
    end
  end
end
