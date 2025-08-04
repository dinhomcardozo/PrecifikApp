module Services
  class ServiceSubproduct < ApplicationRecord
    self.table_name = "service_subproducts"

    belongs_to :service, class_name: "Services::Service"
    belongs_to :subproduct
  end
end