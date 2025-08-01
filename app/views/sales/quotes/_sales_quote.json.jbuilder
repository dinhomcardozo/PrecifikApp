json.extract! sales_quote, :id, : client_id, : channel_cost, : bank_slip_cost, : card_cost, : status, : total, :created_at, :updated_at
json.url sales_quote_url(sales_quote, format: :json)
