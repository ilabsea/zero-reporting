class HubPushNotificationsController < ApplicationController
  # POST /hub_push_notifications
  def create
    if params[:report_id].present?
      if Setting.hub_enabled? && Setting.hub_configured?
        report = Report.find(params[:report_id])
        if report && report.reviewed?
          report.update_attributes({dhis2_submitted: true, dhis2_submitted_at: Time.now, dhis2_submitted_by: current_user.id})

          report.notify_hub!
        end
      else
        render text: "Missing hub configuration", status: :unprocessable_entity
        return
      end
    else
      render text: "Missing report parameter", status: :unprocessable_entity
      return
    end

    head :ok
  end
end
