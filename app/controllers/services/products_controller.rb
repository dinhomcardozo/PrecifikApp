module Services
  class ProductsController < ApplicationController
    include AuthorizationForClients
    before_action :authenticate_user_client!

    def show
      product = Product.find(params[:id])
      render json: {
        cost_per_unit: product.unit_price.to_f
      }
    end
  end
end