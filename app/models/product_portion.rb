class ProductPortion < ApplicationRecord
  belongs_to :product
  has_many :portion_packages, dependent: :destroy
  has_many :packages, through: :portion_packages

  accepts_nested_attributes_for :portion_packages, allow_destroy: true

  before_save :calculate_final_price

  def calculate_final_price
    self.final_package_price = portion_packages.reject(&:marked_for_destruction?)
                                               .sum(&:total_package_price)
  end
end