class Input < ApplicationRecord
    belongs_to :supplier
    belongs_to :input_type
    belongs_to :brand, optional: true

    has_many :subproduct_inputs
    has_many :subproducts, through: :subproduct_inputs
end
