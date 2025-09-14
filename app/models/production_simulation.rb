class ProductionSimulation < ApplicationRecord
  belongs_to :client, class_name: "SystemAdmins::Client"
  belongs_to :created_by, class_name: "SystemAdmins::UserClient"
  belongs_to :updated_by, class_name: "SystemAdmins::UserClient", optional: true
  belongs_to :product

  has_many :simulation_inputs, dependent: :destroy
  has_many :simulation_subproducts, dependent: :destroy
  has_many :simulation_products, dependent: :destroy

  accepts_nested_attributes_for :simulation_inputs, allow_destroy: true
  accepts_nested_attributes_for :simulation_subproducts, allow_destroy: true
  accepts_nested_attributes_for :simulation_products, allow_destroy: true

  before_save :calculate_totals

  private

  def calculate_totals
    self.total_cost = simulation_inputs.sum(:total_cost) + simulation_subproducts.sum(:total_cost)
    # Aqui você pode calcular minimum_selling_price, total_selling_price, etc.
  end
end