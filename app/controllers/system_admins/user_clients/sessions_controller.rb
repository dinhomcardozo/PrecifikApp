module SystemAdmins
  module UserClients
    class SessionsController < Devise::SessionsController
      layout "system_admins"

      skip_before_action :authenticate_user_client!, only: [:new, :create]
    end
  end
end