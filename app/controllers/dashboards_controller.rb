class DashboardsController < ApplicationController
  def index
    @dashboard = Dashboard.new
  end
end