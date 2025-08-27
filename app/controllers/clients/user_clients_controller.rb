module Clients
  class UserClientsController < ApplicationController
    def new
      @user_client = SystemAdmins::UserClient.new
    end
  end
end