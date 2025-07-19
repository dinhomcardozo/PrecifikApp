class CreateSalesTargets < ActiveRecord::Migration[8.0]
  def change
    create_table :sales_targets do |t|
      t.references :package, null: false, foreign_key: true
      t.integer :monthly_target
      t.references :channel, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
