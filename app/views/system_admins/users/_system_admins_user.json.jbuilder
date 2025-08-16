json.extract! system_admins_user, :id, :first_name, :last_name, :email, :phone, :admin, :client_id, :company_id, :created_at, :updated_at
json.url system_admins_user_url(system_admins_user, format: :json)
