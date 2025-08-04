module Services
  class ServiceProduct < ApplicationRecord
    belongs_to :service
    belongs_to :product
  end
end