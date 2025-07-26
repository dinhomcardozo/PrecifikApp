class SimplifyProductFields < ActiveRecord::Migration[8.0]
  def change
    # 1. Remover colunas obsoletas
    remove_column :products, :tax,                   :float
    remove_column :products, :unit_of_measurement,   :string
    remove_column :products, :financial_cost,        :float
    remove_column :products, :sale_price_retail,     :float
    remove_column :products, :sale_price_wholesale,  :float
    remove_column :products, :sales_channel_cost,    :decimal
    remove_column :products, :commission_cost,       :decimal
    remove_column :products, :freight_cost,          :decimal
    remove_column :products, :storage_cost,          :decimal
    remove_column :products, :card_cost,             :decimal
    remove_column :products, :bank_slip,             :decimal

    # 2. Adicionar campos de preços sugeridos
    add_column :products, :suggested_price_retail,    :decimal, precision: 12, scale: 2, default: "0.0", null: false
    add_column :products, :suggested_price_wholesale, :decimal, precision: 12, scale: 2, default: "0.0", null: false
  end
end
