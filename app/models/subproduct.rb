class Subproduct < ApplicationRecord
  belongs_to :brand, optional: true
  has_many :products, through: :product_compositions
  has_many :subproduct_compositions, inverse_of: :subproduct, dependent: :destroy
  has_many :inputs, through: :subproduct_compositions

  validates :name, presence: true

  before_save :recalculate_totals

  accepts_nested_attributes_for :subproduct_compositions,
                                reject_if: :all_blank,
                                allow_destroy: true

  # Helper para view do total
  def total_composition_cost
    subproduct_compositions.sum(&:quantity_cost).to_f.round(2)
  end
  
def cost_per_gram
  weight = weight_in_grams.to_f 
  return 0.0 if weight.zero?     
  (cost.to_f / weight).round(4)
end

  private

  def all_blank(attrs)
    attrs["input_id"].blank? && attrs["quantity_for_a_unit"].to_f <= 0
  end

def recalculate_totals
  self.weight_in_grams = subproduct_compositions.sum(&:quantity_for_a_unit).to_f
  self.cost            = subproduct_compositions.sum(&:quantity_cost).to_f.round(2)
end
end
