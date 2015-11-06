module AuthorizedResource
  extend ActiveSupport::Concern

  included do
    # before_action :required_admin_role!

    rescue_from CanCan::AccessDenied do |exception|
      no_permission exception.message
    end
  end

  def required_admin_role!
    if !current_user.is_admin?
      no_permission("You do not permission to access this page")
    end
  end

  def no_permission message
    sign_out
    redirect_to sign_in_path, alert: message
  end


end