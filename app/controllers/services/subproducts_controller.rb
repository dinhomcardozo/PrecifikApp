module Services
  class SubproductsController < ApplicationController
    include AuthorizationForClients
    before_action :authenticate_user_client!

    def show
      subproduct = Subproduct.find(params[:id])
      render json: {
        cost_per_unit: subproduct.cost_per_gram.to_f
      }
    end
  end
end