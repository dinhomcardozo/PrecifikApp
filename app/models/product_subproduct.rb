class ProductSubproduct < ApplicationRecord
  belongs_to :product,  inverse_of: :product_subproducts, touch: true
  belongs_to :subproduct, optional: true

  before_validation :set_cost, if: -> { subproduct && quantity.present? }
  before_validation :calculate_costs,
                    if: -> { subproduct.present? && quantity.present? }

  # Validar que a quantidade (em g) seja maior que zero (opcional)
  validates :quantity,
            presence: true,
            numericality: { greater_than: 0 }

  after_commit :sync_product_pricing, on: %i[create update]

  after_destroy_commit do
    sync_product_pricing unless product.destroyed?
  end

  private

  def set_cost
    self.cost = (subproduct.cost_per_gram.to_f * quantity.to_f).round(2)
  end

  def calculate_costs
    pct_loss = subproduct.weight_loss.to_f.clamp(0, 100) / 100.0
    base     = subproduct.cost_per_gram.to_f
    adjusted = (base / (1 - pct_loss)).round(6)

    self.cost_per_gram_with_loss = adjusted
    self.cost                   = (quantity.to_f * adjusted).round(4)
  end

  def sync_product_pricing
    return if product.destroyed?

    product.recalculate_weights
    product.compute_total_cost
    product.compute_total_cost_with_taxes
    product.compute_total_cost_with_fixed_costs
    product.compute_suggested_prices

    product.update_columns(
      total_weight:                product.total_weight,
      final_weight:                product.final_weight,
      total_cost:                  product.total_cost,
      total_cost_with_taxes:       product.total_cost_with_taxes,
      total_cost_with_fixed_costs: product.total_cost_with_fixed_costs,
      suggested_price_retail:      product.suggested_price_retail,
      suggested_price_wholesale:   product.suggested_price_wholesale,
      updated_at:                  Time.current
    )
  end
end
