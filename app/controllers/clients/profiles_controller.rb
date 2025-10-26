module Clients
  class ProfilesController < ApplicationController
    layout "application"
    before_action :authenticate_user_client!

    def edit
      @client = current_user_client.client
    end

    def update
      @client = current_user_client.client
      if @client.update(client_params)
        redirect_to edit_clients_profile_path, notice: 'Perfil atualizado.'
      else
        render :edit
      end
    end

    private

    def client_params
      params.require(:client).permit(
        :cnpj, :razao_social, :company_name,
        :first_name, :last_name, :cpf, :phone,
        :address, :number_address, :food_industry
      )
    end
  end
end