module SystemAdmins
  class ApplicationController < ::ApplicationController
    include Pundit::Authorization 
    allow_browser versions: :modern
    before_action :authenticate_user_admin!
    before_action :ensure_user_admin_is_admin!
    layout "system_admins"

    private

    def ensure_user_admin_is_admin!
      unless current_user_admin&.admin?
        redirect_to root_path, alert: "Acesso negado."
      end
    end
  end
end