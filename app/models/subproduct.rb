class Subproduct < ApplicationRecord
  belongs_to :brand, optional: true

  has_many :products, through: :product_compositions
  has_many :subproduct_compositions, inverse_of: :subproduct
  has_many :inputs, through: :subproduct_compositions

  accepts_nested_attributes_for :subproduct_compositions, allow_destroy: true

  private
  
  # ignora campos vazios
  def all_blank(attributes)
    attributes[:input_id].blank? && attributes[:quantity_for_a_unit].to_f <= 0
  end
end
