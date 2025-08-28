module Clients
  class CompleteRegistrationsController < ::ApplicationController
    skip_before_action :ensure_subscription!, only: %i[new create], raise: false
    skip_before_action :ensure_client_profile!, only: %i[new create], raise: false
    layout "auth_layout_application"

    def new
      unless params[:user_client_id].present?
        redirect_to new_user_client_registration_path, alert: "Inicie o cadastro primeiro"
        return
      end

      @user_client = SystemAdmins::UserClient.find_by(id: params[:user_client_id])
      unless @user_client
        redirect_to new_user_client_registration_path, alert: "Usuário não encontrado"
        return
      end

      @client = SystemAdmins::Client.new
    end

    def create
      @client = SystemAdmins::Client.new(client_params)
      @client.plan_id = 4 # Plano Trial

      if @client.save
        @client.update!(signup_date: Time.current)

        user_client = SystemAdmins::UserClient.find(params[:user_client_id])
        user_client.update!(
          client_id: @client.id,
          signup_date: Time.current,
          admin: true
        )

        redirect_to clients_root_path, notice: 'Cadastro completo com sucesso!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def client_params
      params.require(:client).permit(
        :cnpj, :razao_social, :company_name,
        :first_name, :last_name, :cpf, :phone,
        :address, :number_address
      )
    end
  end
end