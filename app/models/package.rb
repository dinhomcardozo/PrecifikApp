class Package < ApplicationRecord
  belongs_to :supplier
  has_many :portion_packages, dependent: :destroy
  has_many :product_portions, through: :portion_packages
end