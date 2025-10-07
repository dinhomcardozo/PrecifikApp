class ProductPortion < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  
  belongs_to :product
  belongs_to :tax, optional: true

  has_many :portion_packages, dependent: :destroy
  has_many :packages, through: :portion_packages
  has_many :channel_product_portions, dependent: :destroy

  has_one :sales_target, inverse_of: :product_portion, dependent: :destroy

  accepts_nested_attributes_for :channel_product_portions, allow_destroy: true
  accepts_nested_attributes_for :portion_packages, allow_destroy: true

  before_save :calculate_totals
  before_validation :set_client_id
  after_save :update_channel_prices
  after_create :ensure_channel_product_portions

  validates :product_id, presence: true
  validates :portioned_quantity, numericality: { greater_than: 0 }
  validates :profit_margin, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  attr_readonly :product_id

  def cost
    return 0 unless product
    (product.cost_per_gram.to_f * portioned_quantity.to_f).round(2)
  end

  def distributed_fixed_cost_per_unit
    SalesTarget.global_distributed_fixed_cost_live
  end

  def packaged_cost
    portion_cost + final_package_price.to_f
  end

  def final_package_price
    portion_packages.sum { |pp| pp.total_package_price.to_f }.round(2)
  end

  def taxes_amount
    return 0 unless tax
    base = cost + distributed_fixed_cost_per_unit
    %i[icms ipi pis_cofins difal iss cbs ibs].sum do |field|
      (tax.send(field).to_f / 100.0) * base
    end.round(2)
  end

  def final_cost
    (cost + distributed_fixed_cost_per_unit + final_package_price.to_f + taxes_amount).round(2)
  end

  def final_price
    (final_cost * (1 + profit_margin.to_f / 100.0)).round(2)
  end

  def net_profit
    (final_price - final_cost.to_f).round(2)
  end

  def real_profit_margin
    return 0 if final_price.to_f.zero?
    ((net_profit.to_f / final_price.to_f) * 100).round(2)
  end

  def channel_row_for(channel)
    channel_product_portions.find_by(channel_id: channel.id) ||
      channel_product_portions.build(channel: channel, client_id: client_id)
  end

  def update_channel_prices
    channel_product_portions.find_each do |cpp|
      cpp.update_columns(effective_final_price: cpp.compute_effective_final_price)
    end
  end

  def ensure_channel_product_portions
    Channel.where(client_id: client_id).find_each do |channel|
      channel_product_portions.find_or_create_by!(channel: channel)
    end
  end

  private

  def calculate_totals
    self[:cost]        = cost
    self[:final_cost]  = final_cost
    self[:final_price] = final_price
  end

  def set_client_id
    self.client_id ||= Current.user_client.client_id if Current.user_client
  end
end