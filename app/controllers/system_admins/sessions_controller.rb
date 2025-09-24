# app/controllers/system_admins/sessions_controller.rb
module SystemAdmins
  class SessionsController < Devise::SessionsController
    skip_before_action :authenticate_user_admin!, only: [:new, :create], raise: false
    skip_before_action :ensure_user_admin_is_admin!, raise: false
    skip_before_action :ensure_subscription!, raise: false

    layout :resolve_layout

    def create
      request.format = :html
      super
    end

    private

    def resolve_layout
      action_name == "new" ? "system_admins_login" : "system_admins"
    end

  end
end