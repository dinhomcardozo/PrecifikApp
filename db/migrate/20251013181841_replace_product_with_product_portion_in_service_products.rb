class ReplaceProductWithProductPortionInServiceProducts < ActiveRecord::Migration[8.0]
  def change
    remove_reference :service_products, :product, foreign_key: true
  end
end