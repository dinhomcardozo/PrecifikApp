class ProductSubproduct < ApplicationRecord
  belongs_to :product
  belongs_to :subproduct
end
