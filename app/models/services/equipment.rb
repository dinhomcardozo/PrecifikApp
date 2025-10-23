module Services
  class Equipment < ApplicationRecord
    self.table_name = 'equipments'

    validates :description, presence: true
    validates :value,
              :depreciation_value,
              presence: true,
              numericality: { greater_than_or_equal_to: 0 }

    validates :depreciation_percent,
          numericality: { greater_than_or_equal_to: 0 },
          format: { with: /\A\d+(\.\d{1,4})?\z/, message: "máximo 4 casas decimais" }


    # Callback para recalcular depreciação antes de salvar
    before_validation :calculate_depreciation_value,
                      if: -> { value_changed? || depreciation_percent_changed? }

    private

    # Define depreciation_value = value * (percent / 100.0)
    def calculate_depreciation_value
      return if value.blank? || depreciation_percent.blank?

      # Trata depreciation_percent como porcentagem (ex: 10.0 = 10%)
      factor = depreciation_percent.to_f / 100.0

      # Multiplica e arredonda para duas casas decimais
      self.depreciation_value = (value.to_f * factor).round(2)
    end
  end
end