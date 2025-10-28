class Input < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  before_save :set_nutritional_defaults
  belongs_to :supplier
  belongs_to :input_type
  belongs_to :brand, optional: false
  scope :resalable, -> { where(resalable_product: true) }
  before_save :calculate_resalable_fields, if: :resalable_product?

  # Serviços diretos (via service_inputs)
  has_many :service_inputs, class_name: 'Services::ServiceInput', inverse_of: :input
  has_many :services, through: :service_inputs, class_name: 'Services::Service'

  has_many :service_subproducts, through: :services, class_name: 'Services::ServiceSubproduct'
  has_many :subproducts_via_services, through: :service_subproducts, source: :subproduct

  self.per_page = 20
  
  has_many :subproduct_compositions, foreign_key: :input_id, inverse_of: :input
  has_many :subproducts, through: :subproduct_compositions
  has_many :input_cost_histories, dependent: :destroy

  has_many :channel_inputs, dependent: :destroy

  after_save :update_channel_prices, if: :resalable_product?
  after_create :ensure_channel_inputs, if: :resalable_product?
  after_update :propagate_weight_change, if: :saved_change_to_weight?

  has_one_attached :image

  validates :name, presence: true
  validates :brand_id, presence: true
  validates_inclusion_of :unit_of_measurement, in: %w[g mL un], message: "não é válido"
  validates :cost, numericality: { greater_than_or_equal_to: 0.0 }, allow_nil: true
  validates :weight, numericality: { greater_than_or_equal_to: 0.0 }, allow_nil: true
  validates :total_fat, :protein, :carbs, :dietary_fiber, :sugars, :sodium,
          numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  after_update_commit :refresh_compositions, if: :saved_change_to_cost?
  after_update_commit :log_cost_change, if: :saved_change_to_cost?

  def weight_in_grams
      case unit_of_measurement
      when 'kg' then weight * 1000
      when 'g' then weight
      when 'L' then weight * 1000
      when 'mL' then weight
      when 'un'  then weight
      when 'm²' then weight
      else
      0
      end
  end

  def cost_per_gram
    return 0.0 if weight_in_grams.to_f.zero?
    (cost.to_f / weight_in_grams.to_f).round(4)
  end

  def refresh_compositions
    subproduct_compositions.includes(subproduct: :products).find_each do |comp|
      comp.send(:compute_quantity_cost)
      comp.save!(validate: false)

      comp.subproduct.products.distinct.find_each do |prod|
        prod.compute_all_pricing_and_weights
        prod.save!(validate: false)
      end
    end
  end

  def channel_row_for(channel)
    channel_inputs.find_by(channel_id: channel.id) ||
      channel_inputs.build(channel: channel, client_id: client_id)
  end

  def update_channel_prices
    channel_inputs.find_each do |ci|
      ci.update_columns(effective_final_price: ci.compute_effective_final_price)
    end
  end

  def ensure_channel_inputs
    Channel.where(client_id: client_id).find_each do |channel|
      channel_inputs.find_or_create_by!(channel: channel)
    end
  end

  def used_in_subproducts?
    subproducts.exists?
  end

  private

  def log_cost_change
    input_cost_histories.create!(
      cost:        cost.to_d,
      recorded_at: Time.current
    )
  end

  def set_nutritional_defaults
    self.total_fat      ||= 0
    self.protein        ||= 0
    self.carbs          ||= 0
    self.dietary_fiber  ||= 0
    self.sugars         ||= 0
    self.sodium         ||= 0
    self.calories       ||= 0
  end

  def calculate_resalable_fields
    self.final_cost = cost.to_f
    self.selling_price = final_cost + (final_cost * profit_margin.to_f / 100.0)
    self.real_profit_margin = selling_price > 0 ? ((selling_price - final_cost) / selling_price) * 100 : 0
  end

  def propagate_weight_change
    subproduct_compositions.find_each do |composition|
      composition.update_columns(
        quantity_for_a_unit: weight.to_f * composition.require_units.to_f
      )
    end
  end
end