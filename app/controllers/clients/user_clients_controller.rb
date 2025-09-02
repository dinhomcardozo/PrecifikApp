module Clients
  class UserClientsController < ApplicationController
    before_action :authenticate_user_client!
    before_action :require_admin_user_client!
    layout 'application'
    before_action :set_user_client, only: [:edit, :update]

    def new
      @user_client = SystemAdmins::UserClient.new
    end

    def edit
      @user_client = SystemAdmins::UserClient.find(params[:id])
    end

    def create
      @user_client = SystemAdmins::UserClient.new(user_client_params)
      @user_client.client_id = current_user_client.client_id

      if @user_client.save
        redirect_to settings_path, notice: 'Usuário criado com sucesso!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @user_client.update(user_client_params)
        redirect_to settings_path, notice: 'Dados atualizados com sucesso!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user_client = SystemAdmins::UserClient.find(params[:id])

      if @user_client == current_user_client
        redirect_to settings_path, alert: 'Você não pode excluir o próprio usuário logado.'
        return
      end

      if current_user_client.admin?
        @user_client.destroy
        redirect_to settings_path, notice: 'Usuário excluído com sucesso!'
      else
        redirect_to settings_path, alert: 'Você não tem permissão para excluir usuários.'
      end
    end

    private

    def set_user_client
      @user_client = current_user_client
    end

    def require_admin_user_client!
      unless current_user_client.admin?
        redirect_to clients_dashboard_path, alert: 'Você não tem permissão para criar usuários. Fale com o seu Administrador do Maxximiza!'
      end
    end

    def user_client_params
      params.require(:user_client).permit(:first_name, :last_name, :email, :admin, :password, :password_confirmation, :client_id)
    end
  end
end