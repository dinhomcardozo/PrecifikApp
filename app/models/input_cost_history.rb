class InputCostHistory < ApplicationRecord
  belongs_to :input

  validates :cost, :recorded_at, presence: true
end
