module Services
  class SubproductsController < ApplicationController
    include AuthorizationForClients
    before_action :authenticate_user_client!

    def show
      subproduct = Subproduct.find(params[:id])
      render json: {
        cost_per_unit: subproduct.unit_price.to_f
      }
    end
  end
end