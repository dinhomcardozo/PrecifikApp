module Clients
  module Sales
    class PriceListsController < ApplicationController
      def index
        @price_lists = PriceList.all
      end

      def show
      end

      def new
      end

      def edit
      end

      def destroy
      end
    end
  end
end
