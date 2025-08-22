# app/controllers/concerns/authorization_for_clients.rb
module AuthorizationForClients
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user_client!
    before_action :check_subscription
    before_action :authorize_module
  end

  private

  def check_subscription
    client = current_user_client.client
    return if client.subscription_active?

    redirect_to root_path, alert: "Sua assinatura expirou ou não está ativa."
  end

  def authorize_module
    namespace = controller_path.split("/").first
    if namespace == "system_admins"
      redirect_to root_path, alert: "Você não tem permissão para acessar este módulo."
    end
  end
end