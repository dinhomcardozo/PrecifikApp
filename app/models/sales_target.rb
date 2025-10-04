class SalesTarget < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  belongs_to :product_portion, optional: false
  has_many :fixed_cost_items

  validates :monthly_target,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }
  validates :start_date, :end_date, presence: true
  validate  :end_after_start
  validate :only_one_active_per_product_portion
  validates :product_portion_id, uniqueness: { message: "já possui uma meta" }

  scope :active_today, ->(today = Date.current) {
    where("start_date <= :today AND end_date >= :today", today: today)
  }

  scope :vencidas, -> { where("end_date < ?", Date.current) }
  scope :vence_hoje, -> { where(end_date: Date.current) }

  def distributed_fixed_cost
    total_fixed_costs     = FixedCost.sum(:monthly_cost)
    total_monthly_targets = SalesTarget.sum(:monthly_target).to_f
    return 0 if total_monthly_targets.zero?

    (total_fixed_costs / total_monthly_targets).round(2)
  end

  def self.global_distributed_fixed_cost_live
    total_fixed = FixedCost.sum(:monthly_cost).to_f
    units = sum(:monthly_target).to_i
    return 0 if units.zero?
    (total_fixed / units).round(2)
  end

  def self.global_distributed_fixed_cost
    global_distributed_fixed_cost_live
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
end