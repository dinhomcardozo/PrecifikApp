class PriceListsProductPortion < ApplicationRecord
  belongs_to :price_list
  belongs_to :product_portion
end
