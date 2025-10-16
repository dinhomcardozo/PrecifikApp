class AddProductPortionToServiceProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :service_products, :product_portion, null: true, foreign_key: true
  end
end