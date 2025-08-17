class CreateInputCostHistories < ActiveRecord::Migration[8.0]
def change
    create_table :input_cost_histories do |t|
      t.references :input, null: false, foreign_key: true
      t.decimal    :cost, precision: 10, scale: 2, null: false
      t.datetime   :recorded_at, null: false, index: true

      t.timestamps
    end
  end
end
