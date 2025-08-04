module Services
  class Service < ApplicationRecord
    self.table_name = "services"

    belongs_to :role
    has_many   :service_professionals, class_name: "Services::ServiceProfessional", dependent: :destroy
    has_many   :professionals, through: :service_professionals

    has_many   :service_energies,    class_name: "Services::ServiceEnergy",    dependent: :destroy
    has_many   :service_equipments,  class_name: "Services::ServiceEquipment",  dependent: :destroy
    has_many   :service_inputs,      class_name: "Services::ServiceInput",      dependent: :destroy
    has_many   :service_subproducts, class_name: "Services::ServiceSubproduct", dependent: :destroy
    has_many   :service_products,    class_name: "Services::ServiceProduct",    dependent: :destroy
  end
end