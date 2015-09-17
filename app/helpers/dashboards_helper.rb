module DashboardsHelper
  def dashboard_cell value, label, reviewed_status
    if value == 0
      content_tag :span, value
    else
      time_line = Dashboard.new.time_line_for(label)
      link_to reports_path(from: time_line[:from].to_date,
                           to: time_line[:to].to_date,
                           reviewed: reviewed_status) do
        content_tag(:span, value, class: 'badge badge-primary')
      end
    end
  end

end