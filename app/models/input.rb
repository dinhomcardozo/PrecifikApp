class Input < ApplicationRecord
    belongs_to :supplier
    belongs_to :input_type
    belongs_to :brand, optional: true

    has_many :subproduct_inputs
    has_many :subproducts, through: :subproduct_inputs

    has_one_attached :image

    validates :name, presence: true
    validates_inclusion_of :unit_of_measurement, in: %w[g mL kg L], message: "não é válido"
    validates :cost, numericality: { greater_than_or_equal_to: 0.0 }, allow_nil: true
    validates :weight, numericality: { greater_than_or_equal_to: 0.0 }, allow_nil: true

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
end