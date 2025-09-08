module Services
  class ProductsController < ApplicationController
    include AuthorizationForClients
    before_action :authenticate_user_client!

    def show
      product = Product.find(params[:id])
      render json: {
        cost_per_unit: product.cost_per_gram.to_f
      }
    end
  end
end