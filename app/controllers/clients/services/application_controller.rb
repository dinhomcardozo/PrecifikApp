# app/controllers/clients/services/application_controller.rb
module Clients
  module Services
    class ApplicationController < Clients::ApplicationController
      before_action :check_services_feature!

      private

      def check_services_feature!
        unless current_user_client.plan.includes?(:services)
          redirect_to clients_dashboard_path, alert: "Seu plano não inclui o módulo Serviços"
        end
      end
    end
  end
end