class ProductSubproduct < ApplicationRecord
  belongs_to :product
  belongs_to :subproduct

  before_validation :set_cost, if: -> { subproduct_id.present? && quantity.present? }

  # Validar que a quantidade (em g) seja maior que zero (opcional)
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  private

  def set_cost
    # subproduct agora é sempre um objeto válido
    self.cost = (subproduct.cost_per_gram.to_f * quantity.to_f).round(2)
  end
end
