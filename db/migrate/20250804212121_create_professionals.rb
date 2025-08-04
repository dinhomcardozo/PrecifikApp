class CreateProfessionals < ActiveRecord::Migration[8.0]
  def change
    create_table :professionals do |t|
      t.string :full_name
      t.references :role, null: false, foreign_key: true
      t.string :cpf
      t.string :company_name
      t.string :cnpj
      t.decimal :average_hourly_rate
      t.decimal :hourly_rate

      t.timestamps
    end
  end
end
