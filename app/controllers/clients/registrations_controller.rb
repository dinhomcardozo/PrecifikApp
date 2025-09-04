module Clients
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :ensure_subscription!, only: %i[new create]
    skip_before_action :ensure_client_profile!, only: %i[new create]

    skip_before_action :ensure_subscription!
    skip_before_action :require_no_authentication, only: %i[new create]
    respond_to :html, :turbo_stream
    layout "auth_layout_application"

    def new
      build_resource
      render :new
    end

    def create
      build_resource(sign_up_params)
      resource.save
      yield resource if block_given?

      if resource.persisted?
        redirect_to new_complete_registration_path(user_client_id: resource.id)
      else
        render :new, status: :unprocessable_entity
      end
    end

    protected

    # def after_sign_up_path_for(resource)
    #   new_complete_registration_path
    # end

    def after_update_path_for(resource)
      if resource.client_id.present?
        settings_path
      else
        complete_registration_path(user_client_id: resource.id)
      end
    end

    def after_update_path_for(resource)
      settings_path
    end

    def sign_up_params
      params.require(:user_client).permit(:email, :password, :password_confirmation)
    end

    def respond_with(resource, _opts = {})
      if resource.errors.empty?
        redirect_to after_sign_up_path_for(resource)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def sign_up_params
      params.require(:user_client).permit(:email, :password, :password_confirmation)
    end
  end
end