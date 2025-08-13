class AddFieldsToServices < ActiveRecord::Migration[8.0]
  def change
    # fk para professionals
    add_reference :services, :professional, null: false, foreign_key: true

    # horas totais (float, obrigatório)
    add_column :services, :total_hours, :float, null: false

    # custo dos itens (decimal, obrigatório, padrão 0.0)
    add_column :services, :service_items_cost, :decimal,
               precision: 10, scale: 2,
               default: "0.0", null: false

    # preço do serviço (decimal, obrigatório, padrão 0.0)
    add_column :services, :service_price, :decimal,
               precision: 10, scale: 2,
               default: "0.0", null: false

    # preço final (decimal, obrigatório, padrão 0.0)
    add_column :services, :final_service_price, :decimal,
               precision: 10, scale: 2,
               default: "0.0", null: false
  end
end
