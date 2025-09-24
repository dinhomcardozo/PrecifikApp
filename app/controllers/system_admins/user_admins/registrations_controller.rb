# app/controllers/system_admins/user_admins/registrations_controller.rb
module SystemAdmins::UserAdmins
  class RegistrationsController < Devise::RegistrationsController
    layout :resolve_layout

    private

    # Parâmetros permitidos no cadastro
    def sign_up_params
      params.require(:user_admin)
            .permit(:email, :password, :password_confirmation)
    end

    # Parâmetros permitidos na edição de perfil
    def account_update_params
      params.require(:user_admin)
            .permit(:email, :password, :password_confirmation, :current_password)
    end

    # Redirect após registro bem-sucedido
    def after_sign_up_path_for(resource)
      dashboard_path
    end

    # Redirect após atualizar a conta
    def after_update_path_for(resource)
      user_admin_path(resource)
    end
  end
end
