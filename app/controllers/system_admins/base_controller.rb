class SystemAdmins::BaseController < SystemAdmins::ApplicationController
  layout 'system_admins'

  layout :resolve_layout

  private

  def resolve_layout
    action_name == "new" ? "system_admins_login" : "system_admins"
  end
end