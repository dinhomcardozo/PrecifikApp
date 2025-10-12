class PriceListRule < ApplicationRecord
  belongs_to :price_list
  belongs_to :product_portion
  belongs_to :channel
end
