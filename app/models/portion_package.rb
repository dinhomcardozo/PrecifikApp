class PortionPackage < ApplicationRecord
  belongs_to :product_portion
  belongs_to :package

  before_save :calculate_total_price

  def calculate_total_price
    self.total_package_price = package.unit_price.to_f * package_units.to_i
  end
end
