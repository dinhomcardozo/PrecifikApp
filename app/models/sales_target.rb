class SalesTarget < ApplicationRecord
  belongs_to :product
  belongs_to :channel

  validates :monthly_target, presence: true,
            numericality: { only_integer: true, greater_than: 0 }
  validates :start_date, :end_date, presence: true
  validate  :end_after_start
  validate  :only_one_active_per_product

  # custo fixo distribuído por unidade
  def distributed_fixed_cost
    return 0 if monthly_target.to_i.zero?
    (total_fixed_cost.to_f / monthly_target).round(2)
  end

  private

  def end_after_start
    return if end_date.blank? || start_date.blank?
    if end_date < start_date
      errors.add(:end_date, "deve ser posterior à data de início")
    end
  end

  def only_one_active_per_product
    return if start_date.blank? || end_date.blank? || product_id.blank?

    overlapping = SalesTarget
      .where(product_id: product_id)
      .where.not(id: id)
      .where("start_date <= ? AND end_date >= ?", end_date, start_date)

    if overlapping.exists?
      errors.add(:product_id,
                 "já possui um target ativo para este produto nesse período")
    end
  end
end
