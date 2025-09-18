class CreateSystemAdminsMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :system_admins_messages do |t|
      t.string  :title, null: false
      t.text    :body, null: false # armazenará HTML do editor rico
      t.text    :client_ids_text   # IDs separados por vírgula
      t.string  :plans, array: true, default: [] # se quiser múltiplos planos
      t.date    :start_date
      t.date    :end_date
      t.time    :start_hour
      t.time    :end_hour

      t.references :created_by, polymorphic: true # para saber quem criou

      t.timestamps
    end
  end
end
