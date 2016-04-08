module Api
  class ApiController < ApplicationController
    skip_before_action :authenticate_user!

    protected

    def authenticate_http_basic
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['API_USERNAME'] && password == ENV['API_CREDENTIAL']
      end
    end

  end
end
