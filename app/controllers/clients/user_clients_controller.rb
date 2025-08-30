module Clients
  class UserClientsController < ApplicationController
    layout 'application'
    before_action :set_user_client, only: [:edit, :update]

    def edit
    end

    def update
      if @user_client.update(user_client_params)
        redirect_to settings_path, notice: 'Dados atualizados com sucesso!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_user_client
      @user_client = current_user_client
    end

    def user_client_params
      params.require(:user_client).permit(:first_name, :last_name, :email)
    end
  end
end