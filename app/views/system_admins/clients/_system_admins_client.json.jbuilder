json.extract! system_admins_client, :id, :razao_social, :company_name, :cnpj, :first_name, :last_name, :cpf, :phone, :address, :number_address, :plan_id, :signup_date, :first_payment, :last_payment, :first_login, :last_login, :created_at, :updated_at
json.url system_admins_client_url(system_admins_client, format: :json)
