json.extract! channel, :id, : description, : channel_cost, : channel_type, :created_at, :updated_at
json.url channel_url(channel, format: :json)
