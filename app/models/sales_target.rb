class SalesTarget < ApplicationRecord
  belongs_to :product, optional: true

  after_commit :recalculate_total_monthly_targets, on: %i[create update destroy]

  validates :monthly_target, presence: true,
            numericality: { only_integer: true, greater_than: 0 }
  validates :start_date, :end_date, presence: true
  validate  :end_after_start
  validate  :only_one_active_per_product
  validates :product_id,
          uniqueness: { message: "já possui uma meta" }

  # custo fixo distribuído por unidade
  def distributed_fixed_cost
    return 0 if monthly_target.to_i.zero?
    (total_fixed_cost.to_f / monthly_target).round(2)
  end

  def recalculate_total_monthly_targets
    total = SalesTarget.sum(:monthly_target)
    # atualiza todas as linhas com o mesmo valor para manter consistência
    SalesTarget.update_all(total_monthly_target: total)
  end

  private

  def end_after_start
    return if end_date.blank? || start_date.blank?
    if end_date < start_date
      errors.add(:end_date, "deve ser posterior à data de início")
    end
  end

  def only_one_active_per_product
    overlapping = SalesTarget
      .where(product_id: product_id)
      .where.not(id: id)
      .where("start_date <= ? AND end_date >= ?", end_date, start_date)
      .exists?

    errors.add(:base, "Já existe uma meta ativa para este produto nesse período") if overlapping
  end
end
