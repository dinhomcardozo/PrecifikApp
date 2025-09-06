module Services
  class InputsController < ApplicationController
    include AuthorizationForClients
    before_action :authenticate_user_client!

    def show
      input = Input.find(params[:id])
      render json: {
        cost_per_unit: input.cost_per_gram.to_f
      }
    end
  end
end