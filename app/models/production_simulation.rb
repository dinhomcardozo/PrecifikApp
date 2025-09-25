class ProductionSimulation < ApplicationRecord
  belongs_to :client, class_name: "SystemAdmins::Client"
  belongs_to :created_by, class_name: "SystemAdmins::UserClient"
  belongs_to :updated_by, class_name: "SystemAdmins::UserClient", optional: true
  belongs_to :product, optional: false

  has_many :simulation_inputs, dependent: :destroy
  has_many :simulation_subproducts, dependent: :destroy
  has_many :simulation_products, dependent: :destroy

  validates :product, presence: true
  validates :client_id, presence: true
  validate :product_must_belong_to_same_client

  accepts_nested_attributes_for :simulation_inputs, allow_destroy: true
  accepts_nested_attributes_for :simulation_subproducts, allow_destroy: true
  accepts_nested_attributes_for :simulation_products, allow_destroy: true

  before_save :calculate_totals

  def calculate_totals
    self.total_cost = simulation_inputs.sum(:total_cost) + simulation_subproducts.sum(:total_cost)
    self.minimum_selling_price = product.suggested_price_wholesale if product&.suggested_price_wholesale.present?
    self.total_retail_profit = (product.net_profit_retail || 0) * (product_units || 0)
    self.total_wholesale_profit = (product.net_profit_wholesale || 0) * (product_units || 0)
  end

  private

  def product_must_belong_to_same_client
    if product && product.client_id != client_id
      errors.add(:product, "não pertence a este cliente")
    end
  end
end