module EventsHelper
  def status_for_enabled
    '<span class="label label-sm label-primary" style="margin-left: 13px;">Enabled</span>'
  end

  def status_for_disabled
    '<span class="label label-sm label-default" style="margin-left: 13px;">Disabled</span>'
  end
end
