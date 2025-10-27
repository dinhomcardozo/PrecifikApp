class CreateChannelInputs < ActiveRecord::Migration[8.0]
  def change
    create_table :channel_inputs do |t|
      t.references :input, null: false, foreign_key: true
      t.references :channel, null: false, foreign_key: true
      t.decimal :corrected_final_price, precision: 10, scale: 2
      t.decimal :effective_final_price, precision: 10, scale: 2
      t.bigint :client_id, null: false

      t.timestamps
    end
  end
end
