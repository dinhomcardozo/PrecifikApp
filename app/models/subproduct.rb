class Subproduct < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  self.per_page = 20
  
  belongs_to :brand, optional: true
  has_many :subproduct_compositions, inverse_of: :subproduct, dependent: :destroy
  has_many :inputs, through: :subproduct_compositions
  has_many :product_subproducts, inverse_of: :subproduct, dependent: :destroy
  has_many :products, through: :product_subproducts

  # Serviços diretos
  has_many :service_subproducts, class_name: 'Services::ServiceSubproduct', inverse_of: :subproduct
  has_many :services, through: :service_subproducts, class_name: 'Services::Service'

  has_many :products_via_services, through: :services,
            source: :products,
            class_name: 'Product'
  
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

  def nutritional_summary
    totals = {
      calories: 0.0,
      total_fat: 0.0,
      protein: 0.0,
      carbs: 0.0,
      dietary_fiber: 0.0,
      sugars: 0.0,
      sodium: 0.0
    }

    subproduct_compositions.includes(:input).each do |comp|
      next unless comp.input&.weight.to_f > 0

      factor = comp.quantity_for_a_unit.to_f / comp.input.weight.to_f

      totals[:calories]       += comp.input.calories.to_f       * factor
      totals[:total_fat]      += comp.input.total_fat.to_f      * factor
      totals[:protein]        += comp.input.protein.to_f        * factor
      totals[:carbs]          += comp.input.carbs.to_f          * factor
      totals[:dietary_fiber]  += comp.input.dietary_fiber.to_f  * factor
      totals[:sugars]         += comp.input.sugars.to_f         * factor
      totals[:sodium]         += comp.input.sodium.to_f         * factor
    end
  
    totals.transform_values { |v| v.round(2) }
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
      # recalcula custo por grama com perda
      pct_loss = weight_loss.to_f.clamp(0, 100) / 100.0
      base     = cost_per_gram
      adjusted = (base / (1 - pct_loss)).round(6)

      psp.update!(
        cost_per_gram_with_loss: adjusted,
        cost: (psp.quantity.to_f * adjusted).round(4)
      )
    end

    products.distinct.find_each do |prod|
      prod.compute_all_pricing_and_weights
      prod.save!(validate: false, touch: true)
    end
  end
end