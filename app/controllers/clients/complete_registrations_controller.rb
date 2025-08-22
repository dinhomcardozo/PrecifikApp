# app/controllers/clients/complete_registrations_controller.rb
module Clients
  class CompleteRegistrationsController < ApplicationController
    before_action :authenticate_user_client!

    def new
      # inicializa o Client associado ao current_user_client
      @client = current_user_client.build_client
    end

    def create
      @client = current_user_client.build_client(client_params)
      @client.plan_id = Plan.find(4).id  # plano trial

      if @client.save
        # registra entrada em client_plans
        ClientPlan.create!(
          client:     @client,
          plan:       @client.plan,
          started_at: Time.current,
          expires_at: 30.days.from_now
        )

        redirect_to clients_root_path,
                    notice: 'Cadastro completo com sucesso!'
      else
        render :new
      end
    end

    private

    def client_params
      params.require(:client).permit(
        :cnpj,
        :razao_social,
        :company_name,
        :first_name,
        :last_name,
        :phone,
        :address,
        :number_address
      )
    end
  end
end