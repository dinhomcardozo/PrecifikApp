# app/controllers/clients/application_controller.rb
module Clients
  class ApplicationController < ActionController::Base
    before_action :check_subscription
    before_action :authorize_module

    private

    # Free (id=1) nunca expira; outros planos podem ter data de expiração
    def check_subscription
      return if current_user_client.client.plan_id == 1
      if current_user_client.client.last_payment && current_user.client.last_payment < 30.days.ago
        redirect_to clients_dashboard_path, alert: "Sua assinatura expirou."
      end
    end

    # Bloqueia módulos restritos
    RESTRICTED_CONTROLLERS = %w[
      system_admins
    ].freeze

    def authorize_module
      # Dashboard#overview sempre liberado
      return if controller_name == "dashboard" && action_name == "overview"
      if RESTRICTED_CONTROLLERS.include?(controller_name)
        redirect_to clients_dashboard_path,
                    alert: "Você não tem permissão para acessar #{controller_name.humanize}."
      end
    end
  end
end