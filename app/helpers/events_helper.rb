module EventsHelper
  def status_for(is_enabled)
    if is_enabled
      '<span class="label label-sm label-primary" style="margin-left: 13px;">Enabled</span>'
    else
      '<span class="label label-sm label-default" style="margin-left: 13px;">Disabled</span>'
    end
  end
end
