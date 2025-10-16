module Services
  class ServiceProduct < ApplicationRecord
    self.table_name = 'service_products'
    before_validation :calculate_cost

    belongs_to :service,
               class_name: "Services::Service",
               inverse_of: :service_products,
               autosave:   true,
               touch: true
    belongs_to :product_portion, optional: true

    belongs_to :client, class_name: "SystemAdmins::Client"
    validates :client_id, presence: true
    before_validation { self.client_id ||= service&.client_id }

    private

    def calculate_cost
      return if quantity_for_service.blank? || product_portion.blank?

      if product_portion.cost.present?
        self.cost = quantity_for_service.to_f * product_portion.cost.to_f
      end
    end
  end
end