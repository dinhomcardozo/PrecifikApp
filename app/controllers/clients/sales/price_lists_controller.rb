module Clients
  module Sales
    class PriceListsController < ApplicationController
      before_action :set_price_list, only: [:show, :edit, :update, :destroy]

      def index
        @price_lists = PriceList.all
      end

      def show
      end

      def new
        @price_list = PriceList.new
        @price_list.price_list_rules.build # já cria uma regra inicial
      end

      def create
        @price_list = PriceList.new(price_list_params)
        @price_list.client = current_user_client.client  # associa ao cliente logado

        if @price_list.save
          redirect_to sales_price_lists_path, notice: "Lista de preços criada com sucesso."
        else
          Rails.logger.debug @price_list.errors.full_messages
          render :new, status: :unprocessable_entity
        end
      end

      def edit
      end

      def update
        if @price_list.update(price_list_params)
          redirect_to sales_price_lists_path, notice: "Lista de preços criada com sucesso."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @price_list.destroy
        redirect_to clients_sales_price_lists_path, notice: "Lista de preços excluída com sucesso."
      end

      private

      def set_price_list
        @price_list = PriceList.find(params[:id])
      end

      def price_list_params
        params.require(:price_list).permit(
          :description,
          :active,
          product_portion_ids: [],
          channel_ids: [],
          price_list_rules_attributes: [
            :id, :initial_quantity, :final_quantity,
            :discount_type, :discount_value, :_destroy
          ]
        )
      end
    end
  end
end
