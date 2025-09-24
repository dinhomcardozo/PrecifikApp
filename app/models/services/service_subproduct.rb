module Services
  class ServiceSubproduct < ApplicationRecord
    self.table_name = "service_subproducts"
    before_validation :calculate_cost

    belongs_to :service,
               class_name: 'Services::Service',
               inverse_of:  :service_subproducts,
               autosave:    true
    belongs_to :subproduct, optional: true

    belongs_to :client, class_name: "SystemAdmins::Client"
    validates :client_id, presence: true
    before_validation { self.client_id ||= service&.client_id }

    private

    def calculate_cost
      return if quantity_for_service.blank? || subproduct.blank?
      self.cost = quantity_for_service.to_f * subproduct.cost_per_gram.to_f
    end
  end
end