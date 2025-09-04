class Input < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  belongs_to :supplier
  belongs_to :input_type
  belongs_to :brand, optional: true

  self.per_page = 20
  
  has_many :subproduct_compositions, foreign_key: :input_id, inverse_of: :input
  has_many :subproducts, through: :subproduct_inputs
  has_many :input_cost_histories, dependent: :destroy

  has_one_attached :image

  validates :name, presence: true
  validates_inclusion_of :unit_of_measurement, in: %w[g mL kg L], message: "não é válido"
  validates :cost, numericality: { greater_than_or_equal_to: 0.0 }, allow_nil: true
  validates :weight, numericality: { greater_than_or_equal_to: 0.0 }, allow_nil: true

  after_update_commit :refresh_compositions, if: :saved_change_to_cost?
  after_update_commit :log_cost_change, if: :saved_change_to_cost?

  def weight_in_grams
      case unit_of_measurement
      when 'kg' then weight * 1000
      when 'g' then weight
      when 'L' then weight * 1000
      when 'mL' then weight
      else
      0
      end
  end

  def cost_per_gram
    return 0.0 if weight_in_grams.to_f.zero?
    (cost.to_f / weight_in_grams.to_f).round(4)
  end

  def refresh_compositions
    subproduct_compositions.find_each do |comp|
      # Recalcula e força gravação sem validação extra
      comp.send(:compute_quantity_cost)
      comp.save!(validate: false)
    end
  end

  private

  def log_cost_change
    input_cost_histories.create!(
      cost:        cost.to_d,
      recorded_at: Time.current
    )
  end
end