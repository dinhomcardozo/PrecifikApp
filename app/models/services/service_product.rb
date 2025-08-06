module Services
  class ServiceProduct < ApplicationRecord
    self.table_name = 'service_products'
    belongs_to :service
    belongs_to :product
  end
end