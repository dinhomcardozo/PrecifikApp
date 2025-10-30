class ProductSubproduct < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  belongs_to :product,  inverse_of: :product_subproducts, touch: true
  belongs_to :subproduct, optional: true
  belongs_to :input, optional: true

  before_validation :set_cost, if: -> { (subproduct.present? || input.present?) && quantity.present? }
  before_validation :calculate_costs, if: -> { (subproduct.present? || input.present?) && quantity.present? }
  before_save :compute_nutrients
  before_save :set_quantity_with_loss

  # Validar que a quantidade (em g) seja maior que zero (opcional)
  validates :quantity,
            presence: true,
            numericality: { greater_than: 0 }
  validate :subproduct_or_input_present


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
    if subproduct.present?
      self.cost = (subproduct.cost_per_gram.to_f * quantity.to_f).round(2)
    elsif input.present?
      if input.unit_of_measurement == "g" || input.unit_of_measurement == "ml"
        self.cost = (input.cost_per_gram.to_f * quantity.to_f).round(2)
      elsif input.unit_of_measurement == "un"
        self.cost = (input.cost_per_unit.to_f * quantity.to_f).round(2)
      elsif input.unit_of_measurement == "m2"
        self.cost = (input.cost_per_m2.to_f * quantity.to_f).round(2)
      end
    end
  end

  def calculate_costs
    if subproduct.present?
      pct_loss = subproduct.weight_loss.to_f.clamp(0, 100) / 100.0
      base     = subproduct.cost_per_gram.to_f
      adjusted = (base / (1 - pct_loss)).round(6)

      self.cost_per_gram_with_loss = adjusted
      self.cost = (quantity.to_f * adjusted).round(4)

    elsif input.present?
      pct_loss = input.weight_loss.to_f.clamp(0, 100) / 100.0
      base     = input.cost_per_unit_of_measurement.to_f # você define no model Input
      adjusted = (base / (1 - pct_loss)).round(6)

      self.cost_per_gram_with_loss = adjusted
      self.cost = (quantity.to_f * adjusted).round(4)
    end
  end

  def sync_product_pricing
    return if product.destroyed?

    product.recalculate_weights
    product.compute_total_cost

    product.product_portions.find_each(&:save)

    product.update_columns(
      total_weight:  product.total_weight,
      final_weight:  product.final_weight,
      total_cost:    product.total_cost,
      updated_at:    Time.current
    )
  end

  def set_quantity_with_loss
    return unless product.present?
    loss_pct = product.weight_loss.to_f.clamp(0, 100) / 100.0
    self.quantity_with_loss = (quantity.to_f * (1 - loss_pct)).round(2)
  end

  def subproduct_or_input_present
    if subproduct_id.blank? && input_id.blank?
      errors.add(:base, "É necessário informar um Subproduto ou um Insumo")
    elsif subproduct_id.present? && input_id.present?
      errors.add(:base, "Não é permitido informar Subproduto e Insumo ao mesmo tempo")
    end
  end

  def compute_nutrients
    if subproduct.present? && subproduct.weight_in_grams.to_f > 0
      factor = quantity.to_f / subproduct.weight_in_grams.to_f

      self.calories       = subproduct.calories.to_f      * factor
      self.total_fat      = subproduct.total_fat.to_f     * factor
      self.protein        = subproduct.protein.to_f       * factor
      self.carbs          = subproduct.carbs.to_f         * factor
      self.dietary_fiber  = subproduct.dietary_fiber.to_f * factor
      self.sugars         = subproduct.sugars.to_f        * factor
      self.sodium         = subproduct.sodium.to_f        * factor

    elsif input.present?
      # Aqui depende de como você modelou nutrientes no Input
      factor = quantity.to_f / input.base_weight.to_f if input.base_weight.to_f > 0

      self.calories       = input.calories.to_f      * factor
      self.total_fat      = input.total_fat.to_f     * factor
      self.protein        = input.protein.to_f       * factor
      self.carbs          = input.carbs.to_f         * factor
      self.dietary_fiber  = input.dietary_fiber.to_f * factor
      self.sugars         = input.sugars.to_f        * factor
      self.sodium         = input.sodium.to_f        * factor
    end
  end
end
