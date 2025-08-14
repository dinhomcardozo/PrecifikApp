class Subproduct < ApplicationRecord
  belongs_to :brand, optional: true
  has_many :subproduct_compositions, inverse_of: :subproduct, dependent: :destroy
  has_many :inputs, through: :subproduct_compositions
  has_many :product_subproducts, inverse_of: :subproduct, dependent: :destroy
  has_many :products, through: :product_subproducts

  validates :name, presence: true

  after_update_commit :refresh_product_compositions, if: :saved_change_to_cost?
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
    # 3) peso final após perda (%)
    ratio      = (100.0 - (weight_loss.to_f)).clamp(0.0, 100.0) / 100.0
    self.final_weight = (weight_in_grams * ratio).round(4)
  end

  def refresh_product_compositions
    product_subproducts.find_each do |psp|
      # Força recalcular o custo unitário do join
      new_cost = (cost_per_gram * psp.quantity).round(2)
      psp.update_columns(cost: new_cost)
    end

    # Se você grava total_cost em Product, recalcula-os também
    products.distinct.find_each do |prod|
      total = prod.product_subproducts.sum(&:cost)
      prod.update_columns(total_cost: total)
    end
  end
end
