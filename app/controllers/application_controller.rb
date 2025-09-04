class ApplicationController < ActionController::Base
  include Pundit::Authorization 
  helper_method :current_user
  alias_method  :current_user, :current_user_client
  
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :ensure_subscription!, if: :devise_controller?
  before_action :set_current_user_client
  before_action :ensure_client_profile!

  private

  def user_not_authorized
    flash[:alert] = "Você não tem permissão para essa ação."
    redirect_to(request.referrer || root_path)
  end

  def ensure_client_profile!
    return unless user_client_signed_in?

    client_path = new_system_admins_client_path
    on_client_pages = controller_path == 'system_admins/clients' &&
                      %w[new create].include?(action_name)
    return if on_client_pages || devise_controller?

    if current_user_client.client.nil?
      redirect_to client_path,
                  alert: 'Complete seu perfil de empresa antes de prosseguir.'
    end
  end

  def ensure_subscription!
    unless current_user_client&.subscription_active?
      redirect_to clients_root_path,
                  alert: "Sua assinatura expirou ou não está ativa."
    end
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(SystemAdmins::UserClient)
      clients_root_path
    else
      super
    end
  end

  def render_not_found
    render file: Rails.root.join("public/404.html"), status: :not_found
  end

  def set_current_user_client
    Current.user_client = current_user_client
  end
end