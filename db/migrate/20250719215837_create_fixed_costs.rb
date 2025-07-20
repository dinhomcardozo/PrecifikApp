class CreateFixedCosts < ActiveRecord::Migration[8.0]
  def change
    create_table :fixed_costs do |t|
      t.string :description
      t.decimal :monthly_cost
      t.string :fixed_cost_type

      t.timestamps
    end
  end
end
