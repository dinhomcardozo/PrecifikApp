# app/controllers/clients/profiles_controller.rb
module Clients
  class ClientsController < ApplicationController
    before_action :authenticate_user_client!

    def edit
      @client = current_user_client.client
    end

    def update
      @client = current_user_client.client
      if @client.update(public_client_params)
        redirect_to edit_clients_profile_path, notice: 'Perfil atualizado.'
      else
        render :edit
      end
    end

    private

    def public_client_params
      params.require(:client).permit(
        :first_name,
        :last_name,
        :phone,
        :address,
        :number_address
      )
    end
  end
end