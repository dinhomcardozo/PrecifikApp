json.extract! sales_client, :id, :first_name, :last_name, :company, :cnpj, :phone, :email, :address, :number_address, :city, :state, :country, :created_at, :updated_at
json.url sales_client_url(sales_client, format: :json)
