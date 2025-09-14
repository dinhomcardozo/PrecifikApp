class SubproductComposition < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  
  belongs_to :subproduct, touch: true
  belongs_to :input

  # antes de salvar linha, calcula e armazena quantity_cost
  before_validation :set_default_quantity
  before_save       :compute_quantity_cost
  before_save :compute_nutrients
  after_save        :update_parent_totals
  after_destroy     :update_parent_totals
  after_save :update_subproduct_totals
  after_destroy :update_subproduct_totals

  delegate :cost_per_gram, to: :input, allow_nil: true

  validates :input_id, presence: true, uniqueness: { scope: :subproduct_id }
  validates :quantity_for_a_unit,
            presence: true,
            numericality: { greater_than: 0 }

  def compute_nutrients
    return unless input&.weight.to_f > 0

    factor = quantity_for_a_unit.to_f / input.weight.to_f

    self.calories       = input.calories.to_f       * factor
    self.total_fat      = input.total_fat.to_f      * factor
    self.protein        = input.protein.to_f        * factor
    self.carbs          = input.carbs.to_f          * factor
    self.dietary_fiber  = input.dietary_fiber.to_f  * factor
    self.sugars         = input.sugars.to_f         * factor
    self.sodium         = input.sodium.to_f         * factor
  end
  
  def update_subproduct_totals
    subproduct.update(
      calories:       subproduct.subproduct_compositions.sum(:calories),
      total_fat:      subproduct.subproduct_compositions.sum(:total_fat),
      protein:        subproduct.subproduct_compositions.sum(:protein),
      carbs:          subproduct.subproduct_compositions.sum(:carbs),
      dietary_fiber:  subproduct.subproduct_compositions.sum(:dietary_fiber),
      sugars:         subproduct.subproduct_compositions.sum(:sugars),
      sodium:         subproduct.subproduct_compositions.sum(:sodium)
    )
  end

  private

  def set_default_quantity
    self.quantity_for_a_unit ||= 0
  end

  def compute_quantity_cost
    self.quantity_cost = (cost_per_gram.to_f * quantity_for_a_unit.to_f).round(2)
  end

  def update_parent_totals
    sp = subproduct
    sp.update_columns(
      weight_in_grams:      sp.subproduct_compositions.sum(&:quantity_for_a_unit).to_f,
      cost:                  sp.subproduct_compositions.sum(&:quantity_cost).to_f.round(2)
    )
  end
end
