class HubPushNotificationsController < ApplicationController
  authorize_resource :class => false
  before_action :load_user_context, only: :create
  
  # POST /hub_push_notifications
  def create
    raise_error('Missing report parameter') unless params[:report_id].present?
    raise_error('Missing Hub configuration') unless (Setting.hub_enabled? && Setting.hub_configured?)

    report = @user_context.reports.find(params[:report_id])
  
    raise_error('Missing DHIS location reference') unless report.place.has_dhis_location?

    if report && report.reviewed?
      report.update_attributes({dhis2_submitted: true, dhis2_submitted_at: Time.now, dhis2_submitted_by: current_user.id})

      report.notify_hub!
    end

    head :ok
  end

  private

  def load_user_context
    @user_context = UserContext.for(current_user)
  end

  def raise_error message
    raise Errors::UnprocessableEntity.new(message)
  end
end
