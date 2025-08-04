module Services
  class ServiceProfessional < ApplicationRecord
    belongs_to :service
    belongs_to :professional
  end
end