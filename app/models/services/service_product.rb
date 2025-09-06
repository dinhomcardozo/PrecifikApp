module Services
  class ServiceProduct < ApplicationRecord
    self.table_name = 'service_products'
    before_validation :calculate_cost

    belongs_to :service
    belongs_to :product

    private

    def calculate_cost
      return if quantity_for_service.blank? || product.blank?
      self.cost = quantity_for_service.to_f * product.unit_price.to_f
    end
  end
end