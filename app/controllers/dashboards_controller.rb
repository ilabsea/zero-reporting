class DashboardsController < ApplicationController
  authorize_resource
  
  def index
    @dashboard = Dashboard.new
  end
end
