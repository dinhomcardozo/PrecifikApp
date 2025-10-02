class SalesTarget < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  belongs_to :product_portion, optional: false
  has_many :fixed_cost_items

  after_commit :update_global_sums_and_portions, on: %i[create update destroy]

  validates :monthly_target,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }
  validates :start_date, :end_date, presence: true
  validate  :end_after_start
  validate :only_one_active_per_product_portion
  validates :product_portion_id, uniqueness: { message: "já possui uma meta" }

  scope :vencidas, -> { where("end_date < ?", Date.current) }
  scope :vence_hoje, -> { where(end_date: Date.current) }

  def distributed_fixed_cost
    total_fixed_costs     = FixedCost.sum(:monthly_cost)
    total_monthly_targets = SalesTarget.sum(:monthly_target).to_f
    return 0 if total_monthly_targets.zero?

    (total_fixed_costs / total_monthly_targets).round(2)
  end

  def self.global_distributed_fixed_cost
    total_fixed_costs     = FixedCost.sum(:monthly_cost)
    total_monthly_targets = SalesTarget.sum(:monthly_target).to_f
    return 0 if total_monthly_targets.zero?

    (total_fixed_costs / total_monthly_targets).round(2)
  end
  
  private

  def end_after_start
    return if end_date.blank? || start_date.blank?
    if end_date < start_date
      errors.add(:end_date, "deve ser posterior à data de início")
    end
  end

  def only_one_active_per_product_portion
    return if product_portion_id.blank?

    overlapping = SalesTarget
      .where(product_portion_id: product_portion_id)
      .where.not(id: id)
      .where("start_date <= ? AND end_date >= ?", end_date, start_date)
      .exists?

    if overlapping
      errors.add(:base, "Já existe uma meta ativa para esta porção nesse período")
    end
  end

  def update_global_sums_and_portions
    total_fixed_costs     = FixedCost.sum(:monthly_cost)
    total_monthly_targets = SalesTarget.sum(:monthly_target).to_f

    distributed_cost = total_monthly_targets.zero? ? 0 : (total_fixed_costs / total_monthly_targets).round(2)

    SalesTarget.includes(:product_portion).find_each do |st|
      next unless (portion = st.product_portion)

      portion.update_columns(
        fixed_cost: distributed_cost,
        updated_at: Time.current
      )
    end
  end
end