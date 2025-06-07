class Brand < ApplicationRecord
    has_many :inputs
    has_many :subproducts
    has_many :products
end