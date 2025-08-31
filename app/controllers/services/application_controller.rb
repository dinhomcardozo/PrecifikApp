module Services
  class ApplicationController < Clients::ApplicationController
    before_action :check_services_feature!

    private

    def check_services_feature!
      allowed_plan_ids = [1, 2, 3, 4]

      unless allowed_plan_ids.include?(current_user_client.plan.id)
        redirect_to clients_dashboard_path, alert: "Seu plano não inclui o módulo Serviços"
      end
    end
  end
end