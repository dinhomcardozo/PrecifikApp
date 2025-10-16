class Product < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  self.per_page = 20
  
  belongs_to :main_brand, class_name: 'Brand', optional: true
  belongs_to :brand
  belongs_to :category, optional: true
  
  has_many :product_subproducts, inverse_of: :product, dependent: :destroy
  has_many :subproducts, through: :product_subproducts
  has_many   :inputs, through: :subproduct_compositions

  # Porções e embalagens
  has_many :product_portions, dependent: :destroy
  has_many :portion_packages, through: :product_portions
  has_many :packages, through: :portion_packages

  has_many :service_products, through: :product_portions, class_name: 'Services::ServiceProduct'
  has_many :services, through: :service_products, class_name: 'Services::Service'

  has_one_attached :image

  accepts_nested_attributes_for :product_subproducts,
                                allow_destroy: true,
                                reject_if: ->(attrs) { attrs['subproduct_id'].blank? && attrs['quantity'].blank? }

  before_validation :compute_all_pricing_and_weights, if: :needs_recalculation?

  after_save :update_subproducts_quantity_with_loss, if: -> { saved_change_to_weight_loss? || saved_change_to_total_weight? }

  # torna weight “somente em memória” - peso que o usuário digita
  attr_accessor :weight

  #CUSTO TOTAL
  
  def total_cost
    product_subproducts.sum(&:cost)
  end

  def compute_total_cost
    self.total_cost = product_subproducts.sum { |ps| ps.cost.to_f }.round(4)
  end

  def compute_final_cost
    self.final_cost = calculated_final_cost
  end

# 1 – Composição
  def total_weight
    product_subproducts.sum { |ps| ps.quantity.to_f }
  end

  def cost_per_gram
    weight = final_weight.to_f.nonzero? || total_weight.to_f
    return 0.0 if weight.zero?
    (total_cost.to_f / weight).round(4)
  end

  def recalculate_weights
    total_qty = product_subproducts.sum { |ps| ps.quantity.to_f }
    pct_loss  = weight_loss.to_f.clamp(0, 100) / 100.0

    # atribuições em memória, sem tocar o banco agora
    self.total_weight = total_qty.round(4)
    self.final_weight = (total_qty * (1 - pct_loss)).round(4)

    product_subproducts.each do |ps|
      unit_cost       = ps.cost.to_f / ps.quantity.to_f
      cost_with_loss  = (unit_cost / (1 - pct_loss)).round(6)
      total_cost_item = (cost_with_loss * ps.quantity.to_f).round(4)

      ps.cost_per_gram_with_loss = cost_with_loss
      ps.cost                   = total_cost_item
    end
  end

  def needs_recalculation?
    product_subproducts.any?(&:saved_change_to_cost?) ||
      product_subproducts.any?(&:saved_change_to_quantity?) ||
      weight_loss_changed?
  end

  def compute_all_pricing_and_weights
    recalculate_weights
    compute_total_cost
    compute_final_cost
  end

  def calculated_final_cost
    total_cost.to_f.round(2)
  end

  def compute_final_cost
    self.final_cost = calculated_final_cost
  end

  def compute_total_cost
    self.total_cost = product_subproducts.sum { |ps| ps.cost_per_gram_with_loss * ps.quantity }
  end

  def product_subproducts_changed?
    product_subproducts.any?(&:saved_change_to_cost?) ||
    product_subproducts.any?(&:saved_change_to_quantity?)
  end

  def update_subproducts_quantity_with_loss
    product_subproducts.find_each do |ps|
      ps.send(:set_quantity_with_loss)
      ps.update_columns(quantity_with_loss: ps.quantity_with_loss, updated_at: Time.current)
    end
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

    product_subproducts.includes(subproduct: :subproduct_compositions).each do |ps|
      sub_sum = ps.subproduct.nutritional_summary
      factor = ps.quantity.to_f / ps.subproduct.weight_in_grams.to_f

      totals.each_key do |key|
        totals[key] += sub_sum[key].to_f * factor
      end
    end

    totals.transform_values { |v| v.round(2) }
  end

  # Nutrientes por grama antes da perda
  def calories_per_gram_before_loss
    return 0 if total_weight.to_f.zero?
    nutritional_summary[:calories] / total_weight
  end

  # Nutrientes por grama depois da perda
  def calories_per_gram_after_loss
    return 0 if final_weight.to_f.zero?
    nutritional_summary[:calories] / final_weight
  end

  #FILTROS E BUSCA
  scope :with_subproduct_ids, ->(ids)  { joins(:subproducts).where(subproducts: { id: ids }) if ids.present? }
  scope :with_input_ids,      ->(ids)  { joins(:inputs).where(inputs: { id: ids }) if ids.present? }
  scope :with_brand_id,       ->(id)   { where(main_brand_id: id) if id.present? }
  scope :by_name,             ->(dir)  { order(description: dir) if dir.in?(%w[asc desc]) }
  scope :by_cost,             ->(dir)  { order(total_cost: dir)     if dir.in?(%w[asc desc]) }
  scope :search_desc,         ->(q)    { where('description ILIKE ?', "%#{q}%") if q.present? }
end