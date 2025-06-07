class Product < ApplicationRecord
  belongs_to :brand, optional: true

  has_many :product_subproducts
  has_many :subproducts, through: :product_subproducts
end
