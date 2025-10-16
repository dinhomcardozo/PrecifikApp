module Services
  class ServiceInput < ApplicationRecord
    self.table_name = "service_inputs"
    before_validation :calculate_cost

    belongs_to :service,
               class_name: 'Services::Service',
               inverse_of:  :service_inputs,
               autosave:    true,
               touch: true
    belongs_to :input, optional: true

    belongs_to :client, class_name: "SystemAdmins::Client"
    validates :client_id, presence: true
    before_validation { self.client_id ||= service&.client_id }

    private
    
    def calculate_cost
      return if quantity_for_service.blank? || input_id.blank?

      input_record = input || Input.find_by(id: input_id)
      return unless input_record

      self.cost = quantity_for_service.to_f * input_record.cost_per_gram.to_f
    end
  end
end