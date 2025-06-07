class Subproduct < ApplicationRecord
  belongs_to :brand, optional: true

  has_many :subproduct_inputs
  has_many :inputs, through: :subproduct_inputs

  has_many :product_subproducts
  has_many :products, through: :product_subproducts
end
