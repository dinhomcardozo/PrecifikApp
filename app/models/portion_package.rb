class PortionPackage < ApplicationRecord
  belongs_to :product_portion
  belongs_to :package

  before_validation :calculate_total_price

  after_save :update_product_portion

  validates :package_id, presence: true
  validates :package_units, numericality: { greater_than: 0 }
  validates :total_package_price, numericality: { greater_than: 0 }

  def calculate_total_price
    self.total_package_price = package&.unit_price.to_f * package_units.to_i
  end

  private

  def update_product_portion
    product_portion.save # dispara o before_validation do pai e recalcula final_package_price
  end

end
