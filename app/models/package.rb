# app/models/package.rb
class Package < ApplicationRecord
  belongs_to :brand
  belongs_to :channel

  has_many   :package_compositions, inverse_of: :package, dependent: :destroy
  has_many   :products, through: :package_compositions

  accepts_nested_attributes_for :package_compositions,
                                reject_if: :all_blank,
                                allow_destroy: true

  validates :description, presence: true

  # Recalcula totais antes de salvar
  before_save :recalculate_totals

  private

  def recalculate_totals
    # soma pesos
    self.total_weight   = package_compositions.sum(&:weight).to_f

    # soma subtotais (peso * price) ou use subprice já calculado
    self.subtotal_price = package_compositions.sum(&:subprice).to_f.round(2)

    # aplica desconto geral
    disc = general_discount.to_f / 100.0
    self.total_price    = subtotal_price * (1 - disc)

    # final_price = total_price + custos extras (se houver)
    self.final_price    = total_price.round(2)
  end

  # helper para nested_attributes
  def all_blank(attrs)
    attrs["product_id"].blank?
  end
end