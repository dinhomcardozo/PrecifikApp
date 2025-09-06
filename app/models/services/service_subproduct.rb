module Services
  class ServiceSubproduct < ApplicationRecord
    self.table_name = "service_subproducts"
    before_validation :calculate_cost

    belongs_to :service, class_name: "Services::Service"
    belongs_to :subproduct

    private

    def calculate_cost
      return if quantity_for_service.blank? || subproduct.blank?
      self.cost = quantity_for_service.to_f * subproduct.unit_price.to_f
    end
  end
end