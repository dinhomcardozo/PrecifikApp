class ProductPortion < ApplicationRecord
  belongs_to :product
  belongs_to :client
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  has_many :portion_packages, dependent: :destroy
  has_many :packages, through: :portion_packages

  accepts_nested_attributes_for :portion_packages, allow_destroy: true

  before_save :calculate_final_price
  before_validation :set_client_id

  validates :product_id, presence: true
  validates :portioned_quantity, numericality: { greater_than: 0 }

  def calculate_final_price
    self.final_package_price = portion_packages.reject(&:marked_for_destruction?)
                                              .sum { |pp| pp.total_package_price.to_f }
  end

  def portion_cost
    product.cost_per_gram.to_f * portioned_quantity.to_f
  end

  def packaged_cost
    portion_cost + final_package_price.to_f
  end

  def packaged_price_retail
    packaged_cost * (1 + product.profit_margin_retail.to_f / 100)
  end

  def packaged_price_wholesale
    packaged_cost * (1 + product.profit_margin_wholesale.to_f / 100)
  end

  private

  def set_client_id
    self.client_id ||= Current.user_client.client_id if Current.user_client
  end
end