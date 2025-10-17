class PriceListRule < ApplicationRecord
  belongs_to :price_list

  validates :initial_quantity, :final_quantity,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :final_greater_than_initial

  private

  def final_greater_than_initial
    return if final_quantity.blank? || initial_quantity.blank?

    if final_quantity <= initial_quantity
      errors.add(:final_quantity, "deve ser maior que o campo 'De'")
    end
  end
end
