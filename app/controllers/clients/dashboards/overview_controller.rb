module Clients
  module Dashboards
    class OverviewController < Clients::AuthenticatedController
      layout "application"
      def index
        @banners = SystemAdmins::Banner.for_client(current_user_client.client)
      end
    end
  end
end