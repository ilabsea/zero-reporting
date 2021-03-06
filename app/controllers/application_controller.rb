class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Authenticable
  include AuthorizedResource

  include Errors::RescueError

  helper_method :current_user

end
