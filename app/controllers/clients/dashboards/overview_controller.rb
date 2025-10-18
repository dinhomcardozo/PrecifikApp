module Clients
  module Dashboards
    class OverviewController < Clients::AuthenticatedController
      layout "application"
      def index
        @inputs_count = Input.count
        @subproducts_count = Subproduct.count
        @products_count = Product.count
        @product_portions_count = ProductPortion.count
        @banners = SystemAdmins::Banner.for_client(current_user_client.client)
      end
    end
  end
end