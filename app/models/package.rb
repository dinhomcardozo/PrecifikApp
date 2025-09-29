class Package < ApplicationRecord
  belongs_to :supplier
  has_many :portion_packages, dependent: :destroy
  has_many :product_portions, through: :portion_packages

  after_save :update_portion_packages

  private

  def update_portion_packages
    portion_packages.find_each(&:save)
  end
end