class Category < ApplicationRecord
  has_many :products, dependent: :nullify
end