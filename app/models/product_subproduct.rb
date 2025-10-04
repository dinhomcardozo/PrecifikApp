class ProductSubproduct < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  belongs_to :product,  inverse_of: :product_subproducts, touch: true
  belongs_to :subproduct, optional: true

  before_validation :set_cost, if: -> { subproduct && quantity.present? }
  before_validation :calculate_costs,
                    if: -> { subproduct.present? && quantity.present? }
  before_save :compute_nutrients
  before_save :set_quantity_with_loss

  # Validar que a quantidade (em g) seja maior que zero (opcional)
  validates :quantity,
            presence: true,
            numericality: { greater_than: 0 }

  after_commit :sync_product_pricing, on: %i[create update]
  after_commit :update_product_totals, on: %i[create update destroy]

  after_destroy_commit do
    sync_product_pricing unless product.destroyed?
  end

  def compute_nutrients
    return unless subproduct&.weight_in_grams.to_f > 0

    factor = quantity.to_f / subproduct.weight_in_grams.to_f

    self.calories       = subproduct.calories.to_f       * factor
    self.total_fat      = subproduct.total_fat.to_f      * factor
    self.protein        = subproduct.protein.to_f        * factor
    self.carbs          = subproduct.carbs.to_f          * factor
    self.dietary_fiber  = subproduct.dietary_fiber.to_f  * factor
    self.sugars         = subproduct.sugars.to_f         * factor
    self.sodium         = subproduct.sodium.to_f         * factor
  end

  def update_product_totals
    return if product.destroyed?

    totals = {
      calories:      product.product_subproducts.sum(:calories),
      total_fat:     product.product_subproducts.sum(:total_fat),
      protein:       product.product_subproducts.sum(:protein),
      carbs:         product.product_subproducts.sum(:carbs),
      dietary_fiber: product.product_subproducts.sum(:dietary_fiber),
      sugars:        product.product_subproducts.sum(:sugars),
      sodium:        product.product_subproducts.sum(:sodium)
    }

    product.update_columns(totals.merge(updated_at: Time.current))
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
    product.compute_suggested_prices

    product.update_columns(
      total_weight:           product.total_weight,
      final_weight:           product.final_weight,
      total_cost:             product.total_cost,
      suggested_price_retail: product.suggested_price_retail,
      updated_at:             Time.current
    )
  end

  def set_quantity_with_loss
    return unless product.present?
    loss_pct = product.weight_loss.to_f.clamp(0, 100) / 100.0
    self.quantity_with_loss = (quantity.to_f * (1 - loss_pct)).round(2)
  end
end
