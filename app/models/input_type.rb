class InputType < ApplicationRecord
  has_many :inputs

  validates :name, presence: true, uniqueness: true
end