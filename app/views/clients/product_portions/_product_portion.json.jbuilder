json.extract! product_portion, :id, :product_id, :portioned_quantity, :final_package_price, :active, :created_at, :updated_at
json.url product_portion_url(product_portion, format: :json)
