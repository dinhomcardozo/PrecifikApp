class FixedCost < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }

  after_commit :recalculate_fixed_costs, on: %i[create update destroy]

  FIXED_COST_TYPES = [
    "Aluguel",
    "Softwares",
    "Serviços",
    "Salários Fixos",
    "Benefícios",
    "Máquinas e Equipamentos",
    "Licenças",
    "Outros"
  ].freeze

  validates :description, presence: true
  validates :monthly_cost,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :fixed_cost_type,
            presence: true,
            inclusion: { in: FIXED_COST_TYPES }

  private

  def recalculate_fixed_costs
    ProductPortion.distribute_fixed_costs!
  end
end