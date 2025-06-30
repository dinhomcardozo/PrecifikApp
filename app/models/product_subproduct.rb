class ProductSubproduct < ApplicationRecord
  belongs_to :product
  belongs_to :subproduct

  before_validation :set_cost

  # Validar que a quantidade (em g) seja maior que zero (opcional)
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  private

  def set_cost
    # Subproduct.cost_per_gram deve existir (cost / weight_in_grams)
    self.cost = (subproduct.cost_per_gram.to_f * quantity.to_f).round(2)
  end
end
