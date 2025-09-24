module SystemAdmins
  class ApplicationController < ActionController::Base
    include Pundit::Authorization
    allow_browser versions: :modern
    layout 'system_admins'

    before_action :authenticate_user_admin!
    before_action :ensure_user_admin_is_admin!

    private

    def ensure_user_admin_is_admin!
      unless current_user_admin&.admin?
        redirect_to root_path, alert: "Acesso negado."
      end
    end

    def after_sign_out_path_for(resource_or_scope)
      if resource_or_scope == :user_admin
        new_user_admin_session_path # => /system_admins/entrar
      else
        super
      end
    end
  end
end