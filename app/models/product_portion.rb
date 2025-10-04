class ProductPortion < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }

  belongs_to :product
  belongs_to :tax, optional: true
  has_many :portion_packages, dependent: :destroy
  has_many :packages, through: :portion_packages
  has_one :sales_target, inverse_of: :product_portion, dependent: :destroy

  accepts_nested_attributes_for :portion_packages, allow_destroy: true

  before_save :calculate_totals
  before_validation :set_client_id

  validates :product_id, presence: true
  validates :portioned_quantity, numericality: { greater_than: 0 }

  def distributed_fixed_cost_per_unit
    SalesTarget.global_distributed_fixed_cost_live
  end

  def portion_cost
    product.cost_per_gram.to_f * portioned_quantity.to_f
  end

  def packaged_cost
    portion_cost + final_package_price.to_f
  end

  def total_taxes_amount
    return 0 unless tax

    %i[icms ipi pis_cofins difal iss cbs ibs].sum do |field|
      (tax.send(field).to_f / 100.0) * (product.total_cost.to_f + distributed_fixed_cost_per_unit.to_f)
    end.round(2)
  end

  def final_cost
    base     = product&.total_cost.to_f
    fixed    = distributed_fixed_cost_per_unit.to_f
    taxes    = total_taxes_amount
    packages = final_package_price.to_f

    (fixed + taxes + packages).round(2)
  end

  def final_price
    base     = product&.total_cost.to_f
    fixed    = distributed_fixed_cost_per_unit.to_f
    taxes    = total_taxes_amount
    packages = final_package_price.to_f

    (base + fixed + taxes + packages).round(2)
  end

  private

  def calculate_totals
    self.final_package_price = portion_packages.reject(&:marked_for_destruction?)
                                               .sum { |pp| pp.total_package_price.to_f }

    self.final_cost  = final_cost
    self.final_price = final_price
  end

  def set_client_id
    self.client_id ||= Current.user_client.client_id if Current.user_client
  end
end