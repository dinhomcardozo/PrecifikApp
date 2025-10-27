class AddResalableFieldsToInputs < ActiveRecord::Migration[8.0]
  def change
    add_column :inputs, :profit_margin, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :inputs, :final_cost, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :inputs, :selling_price, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :inputs, :real_profit_margin, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
