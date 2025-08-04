class ProductSubproduct < ApplicationRecord
  belongs_to :product,  inverse_of: :product_subproducts, touch: true
  belongs_to :subproduct

  before_validation :set_cost, if: -> { subproduct && quantity.present? }

  # Validar que a quantidade (em g) seja maior que zero (opcional)
  validates :quantity,
            presence: true,
            numericality: { greater_than: 0 }

  after_save :update_parent_product

  private

  def set_cost
    self.cost = (subproduct.cost_per_gram.to_f * quantity.to_f).round(2)
  end

  def update_parent_product
    product.store_total_cost
    product.store_total_cost_with_fixed_costs
  end
end
