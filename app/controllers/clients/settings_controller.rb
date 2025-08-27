# app/controllers/clients/settings_controller.rb
module Clients
  class SettingsController < ApplicationController
    before_action :authenticate_user_client!
    layout "application"

    def show
      @user_client  = current_user_client
      @client       = @user_client.client
      @plan         = @client.plan
      @user_clients = @client.user_clients if @user_client.admin?
    end
  end
end