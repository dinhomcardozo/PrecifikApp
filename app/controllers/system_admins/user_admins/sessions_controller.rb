# app/controllers/system_admins/user_admins/sessions_controller.rb
module SystemAdmins::UserAdmins
  class SessionsController < Devise::SessionsController
    layout "system_admins"  # seu layout de admin
  end
end