class AddReadAtToMessageReadsTwo < ActiveRecord::Migration[8.0]
  def change
    add_column :message_reads, :read_at, :datetime
  end
end
