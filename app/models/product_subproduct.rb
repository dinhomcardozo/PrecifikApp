class ProductSubproduct < ApplicationRecord
  belongs_to :product
  belongs_to :subproduct

  # Validar que a quantidade (em g) seja maior que zero (opcional)
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
