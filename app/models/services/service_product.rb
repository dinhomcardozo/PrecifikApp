module Services
  class ServiceProduct < ApplicationRecord
    self.table_name = 'service_products'
    before_validation :calculate_cost

    belongs_to :service,
               class_name: "Services::Service",
               inverse_of: :service_products,
               autosave:   true
    belongs_to :product, optional: true

    private

    def calculate_cost
      return if quantity_for_service.blank? || product.blank?
      self.cost = quantity_for_service.to_f * product.cost_per_gram.to_f
    end
  end
end