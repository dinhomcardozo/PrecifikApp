module SystemAdmins::UserAdmins
  class SessionsController < Devise::SessionsController
    layout :resolve_layout

    private

    def resolve_layout
      if action_name == "new"
        "system_admins_login"
      else
        "system_admins"
      end
    end
  end
end