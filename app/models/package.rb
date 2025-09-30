class Package < ApplicationRecord
  belongs_to :supplier
  belongs_to :client
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  has_many :portion_packages, dependent: :destroy
  has_many :product_portions, through: :portion_packages

  before_validation :set_client_id

  after_save :update_portion_packages

  private

  def update_portion_packages
    portion_packages.find_each(&:save)
  end

  def set_client_id
    self.client_id ||= Current.user_client.client_id if Current.user_client
  end
end