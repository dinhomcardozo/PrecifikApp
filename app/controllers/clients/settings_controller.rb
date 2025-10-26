# app/controllers/clients/settings_controller.rb
module Clients
  class SettingsController < ApplicationController
    before_action :authenticate_user_client!
    layout "application"

    def update
      @client = current_user_client.client
      if @client.update(client_params)
        redirect_to settings_path, notice: "Configurações atualizadas com sucesso."
      else
        flash.now[:alert] = "Não foi possível atualizar as configurações."
        render :show, status: :unprocessable_entity
      end
    end

    def show
      @user_client  = current_user_client
      @client       = @user_client.client
      @plan         = @client.plan
      @user_clients = @client.user_clients if @user_client.admin?
    end

    private

    def client_params
      params.require(:client).permit(
        :razao_social,
        :company_name,
        :cnpj,
        :address,
        :number_address,
        :food_industry
      )
    end
  end
end