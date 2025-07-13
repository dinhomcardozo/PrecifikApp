class SubproductComposition < ApplicationRecord
  belongs_to :subproduct
  belongs_to :input

  # antes de salvar linha, calcula e armazena quantity_cost
  before_validation :set_default_quantity
  before_save       :compute_quantity_cost

  delegate :cost_per_gram, to: :input, allow_nil: true

  validates :input_id, presence: true, uniqueness: { scope: :subproduct_id }
  validates :quantity_for_a_unit,
            presence: true,
            numericality: { greater_than: 0 }
  

  private

  def set_default_quantity
    self.quantity_for_a_unit ||= 0
  end

  def compute_quantity_cost
    self.quantity_cost = (cost_per_gram.to_f * quantity_for_a_unit.to_f).round(2)
  end
end
