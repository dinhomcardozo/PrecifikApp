json.extract! sales_order, :id, :sales_quote_id, :status, :placed_at, :total, :created_at, :updated_at
json.url sales_order_url(sales_order, format: :json)
