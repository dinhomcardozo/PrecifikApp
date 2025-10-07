module Clients
  class ChannelProductPortionsController < ApplicationController
    before_action :set_channel_product_portion, only: [:update]

    def update
      if @channel_product_portion.update(channel_product_portion_params)
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_back fallback_location: clients_product_portions_path, notice: "Preço atualizado." }
        end
      else
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_back fallback_location: clients_product_portions_path, alert: "Erro ao atualizar." }
        end
      end
    end

    private

    def set_channel_product_portion
      @channel_product_portion = ChannelProductPortion.find(params[:id])
    end

    def channel_product_portion_params
      params.require(:channel_product_portion).permit(:corrected_final_price, :channel_id)
    end
  end
end