class SubproductComposition < ApplicationRecord
  belongs_to :subproduct
  belongs_to :input

  validates :quantity_for_a_unit, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :input_id, uniqueness: { scope: :subproduct_id, message: "já está na lista" }
  validates_presence_of :input_id, :quantity_for_a_unit

  def quantity_cost
    return 0.0 if input.nil? || quantity_for_a_unit <= 0
    (input.cost / input.weight_in_grams) * quantity_for_a_unit
  rescue ZeroDivisionError
    0.0
  end
end
