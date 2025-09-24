module SystemAdmins::UserAdmins
  class SessionsController < Devise::SessionsController
    skip_before_action :authenticate_user_admin!, only: [:new, :create], raise: false
    skip_before_action :ensure_user_admin_is_admin!, raise: false
    skip_before_action :ensure_subscription!, raise: false
    skip_before_action :authenticate_user_client!, raise: false

    layout :resolve_layout

    def new
      self.resource = SystemAdmins::UserAdmin.new
      Rails.logger.info "DEBUG Devise resource: #{resource.inspect}"
      super
    end

    def create
      request.format = :html
      Rails.logger.info "DEBUG Devise resource: #{resource.inspect}"
      super
    end

    private

    def resolve_layout
      action_name == "new" ? "system_admins_login" : "system_admins"
    end

    def after_sign_in_path_for(resource)
      system_admins_root_path
    end
  end
end