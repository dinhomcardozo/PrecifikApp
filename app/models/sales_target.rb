class SalesTarget < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  belongs_to :product, optional: true
  has_many :fixed_cost_items

  after_commit :update_global_sums, on: %i[create update destroy]

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

  def recalc_total_fixed_cost!
    update_column(:total_fixed_cost, fixed_cost_items.sum(:amount))
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

  def update_global_sums
    total  = SalesTarget.sum(:monthly_target)
    today  = Date.current
    active = SalesTarget
               .where("start_date <= ? AND end_date >= ?", today, today)
               .sum(:monthly_target)

    # Atualiza todas as linhas para manter os dois campos sincronizados
    SalesTarget.update_all(
      sales_target_sum: total,
      sales_target_active_sum: active
    )
  end
end
