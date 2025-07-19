class CreateChannels < ActiveRecord::Migration[8.0]
  def change
    create_table :channels do |t|
      t.string :description
      t.decimal :channel_cost
      t.string :channel_type

      t.timestamps
    end
  end
end
