class SalesTarget < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  belongs_to :product, optional: true
  has_many :fixed_cost_items

  after_commit :update_global_sums_and_products, on: %i[create update destroy]

  validates :monthly_target,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }
  validates :start_date, :end_date, presence: true
  validate  :end_after_start
  validate  :only_one_active_per_product
  validates :product_id,
          uniqueness: { message: "já possui uma meta" }

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

  def only_one_active_per_product
    overlapping = SalesTarget
      .where(product_id: product_id)
      .where.not(id: id)
      .where("start_date <= ? AND end_date >= ?", end_date, start_date)
      .exists?

    if overlapping
      errors.add(:base, "Já existe uma meta ativa para este produto nesse período")
    end
  end

  def update_global_sums_and_products
    # 1) somatórios globais
    total  = SalesTarget.sum(:monthly_target)
    today  = Date.current
    active = SalesTarget
               .where("start_date <= ? AND end_date >= ?", today, today)
               .sum(:monthly_target)

    SalesTarget.update_all(
      sales_target_sum: total,
      sales_target_active_sum: active
    )

    # 2) aplica custo fixo distribuído global nos produtos
    total_fixed_costs     = FixedCost.sum(:monthly_cost)
    total_monthly_targets = SalesTarget.sum(:monthly_target).to_f

    # se não há metas, zera o efeito nos products que têm meta
    if total_monthly_targets.zero?
      SalesTarget.includes(:product).find_each do |st|
        next unless (prod = st.product)

        # recomputa só o total_cost_with_fixed_costs removendo distribuição
        new_total_with_fixed = (prod.total_cost.to_f + 0.0).round(2)

        prod.update_columns(
          total_cost_with_fixed_costs: new_total_with_fixed,
          updated_at: Time.current
        )
      end
      return
    end

    # custo fixo global por unidade (igual para todos)
    distributed_cost = (total_fixed_costs / total_monthly_targets).round(2)

    SalesTarget.includes(:product).find_each do |st|
      next unless (prod = st.product)

      # aplica a distribuição global ao product
      new_total_with_fixed = (prod.total_cost.to_f + distributed_cost).round(2)

      prod.update_columns(
        fixed_cost: distributed_cost,
        total_cost_with_fixed_costs: (prod.total_cost.to_f + distributed_cost).round(2),
        updated_at: Time.current
      )
    end
  end
end