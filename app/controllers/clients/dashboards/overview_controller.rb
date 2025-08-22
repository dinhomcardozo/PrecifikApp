module Clients
  module Dashboards
    class OverviewController < Clients::AuthenticatedController
      def index
        @banners = SystemAdmins::Banner.active.order(:start_date)
      end
    end
  end
end