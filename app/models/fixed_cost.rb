class FixedCost < ApplicationRecord
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
end