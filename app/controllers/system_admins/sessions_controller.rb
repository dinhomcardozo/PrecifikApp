# app/controllers/system_admins/sessions_controller.rb
module SystemAdmins
  class SessionsController < Devise::SessionsController
    layout 'system_admins'
    skip_before_action :authenticate_user_admin!, only: [:new, :create]
  end
end