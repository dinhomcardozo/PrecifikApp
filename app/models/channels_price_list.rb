class ChannelsPriceList < ApplicationRecord
  belongs_to :price_list
  belongs_to :channel
end
