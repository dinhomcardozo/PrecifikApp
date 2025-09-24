# app/controllers/system_admins/dashboard_controller.rb
module SystemAdmins
  class DashboardController < SystemAdmins::BaseController
    before_action :authenticate_user_client!

    def index
      # Aqui current_user é SystemAdmins::User (client_user)
      # Você pode checar planos, features, etc.
    end
  end
end