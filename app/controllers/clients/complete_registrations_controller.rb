# app/controllers/clients/complete_registrations_controller.rb
module Clients
  class CompleteRegistrationsController < ApplicationController
    before_action :authenticate_user_client!

    def new
      # inicializa o Client associado ao current_user_client
      @client = current_user_client.build_client
    end

    def create
      @client = SystemAdmins::Client.new(client_params)
      @client.plan_id = 4 # plano trial padrão

      if @client.save
        current_user_client.update!(client_id: @client.id)
        redirect_to clients_root_path, notice: "Cadastro completo com sucesso!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def client_params
      params.require(:client).permit(
        :cnpj, :razao_social, :company_name,
        :first_name, :last_name, :phone,
        :address, :number_address
      )
    end
  end
end