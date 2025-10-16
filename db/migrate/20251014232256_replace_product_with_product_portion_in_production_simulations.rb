class ReplaceProductWithProductPortionInProductionSimulations < ActiveRecord::Migration[8.0]
  def change
    if column_exists?(:production_simulations, :product_id)
      remove_reference :production_simulations, :product, foreign_key: true
    end

    add_reference :production_simulations, :product_portion, foreign_key: true
  end
end
