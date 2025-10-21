class AddImageToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :image, :string
  end
end
