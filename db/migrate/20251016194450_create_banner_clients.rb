class CreateBannerClients < ActiveRecord::Migration[8.0]
def change
    create_table :banner_clients do |t|
      t.references :banner, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
