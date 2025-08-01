class Sales::Order < ApplicationRecord
  belongs_to :sales_quote
end
