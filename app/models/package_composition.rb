# app/models/package_composition.rb
class PackageComposition < ApplicationRecord
  belongs_to :package
  belongs_to :product

  # antes de validar, calcula preço e subprice
  before_validation :compute_prices

  validates :product_id, presence: true
  validates :weight,     presence: true, numericality: { greater_than: 0 }

  private

  def compute_prices
    # ex.: price por g definido em Product.cost_per_gram
    unit_cost      = product.cost_per_gram.to_f
    self.price     = (unit_cost * weight).round(2)
    # aplica desconto local
    disc           = discount.to_f / 100.0
    self.subprice  = (price * (1 - disc)).round(2)
  end
end