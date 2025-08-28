# app/controllers/system_admins/user_clients/sessions_controller.rb
module Clients
  class SessionsController < Devise::SessionsController
    skip_before_action :ensure_subscription!
    layout "auth_layout_application"

    protected

    def after_sign_in_path_for(resource)
      clients_root_path
    end
  end
end