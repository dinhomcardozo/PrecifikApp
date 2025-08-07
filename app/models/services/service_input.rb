module Services
  class ServiceInput < ApplicationRecord
    self.table_name = "service_inputs"

    belongs_to :service,
               class_name: 'Services::Service',
               inverse_of:  :service_inputs
    belongs_to :input
  end
end