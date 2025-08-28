module Clients
  class AuthenticatedController < ApplicationController
    include Pundit::Authorization
    before_action :authenticate_user_client!
    before_action :ensure_subscription!
    layout "auth_layout_application"

    private

    def ensure_subscription!
      return if current_user_client&.subscription_active?
      redirect_to subscription_plans_path, alert: "Você precisa escolher um plano para continuar."
    end

    def pundit_user
      current_user_client
    end

    def default_policy_class
      ClientsPolicy
    end

    def authorize(record, query = nil, policy_class: default_policy_class)
      super(record, query, policy_class: policy_class)
    end
  end
end
