class CreateMessageReads < ActiveRecord::Migration[8.0]
  def change
    create_table :message_reads do |t|
      t.references :message, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
