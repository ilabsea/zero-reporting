class HubNotificationsController < ApplicationController
  # POST /hub_notifications
  def create
    if params[:report_id].present?
      report = Report.find(params[:report_id])
      if report
        report.update_attributes({dhis2_submitted: true, dhis2_submitted_at: Time.now, dhis2_submitted_by: current_user.id})

        report.notify_hub!
      end
    else
      head :unprocessible_entity
    end

    head :ok
  end
end
