class Brand < ApplicationRecord
    has_many :inputs
    has_many :subproducts
    has_many :products

    scope :main_brands, -> { where(main_brand: true) }
end