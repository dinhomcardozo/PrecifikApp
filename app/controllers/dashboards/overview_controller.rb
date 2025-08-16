module Dashboards
  class OverviewController < ApplicationController
    def index
      @banners = SystemAdmins::Banner.active.order(:start_date)
    end
  end
end