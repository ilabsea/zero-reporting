module Alert
  class Place::ReporterAlert < PlaceAlert
    def enabled?
      super && @setting.has_recipient?(HC.kind)
    end

    def message_template
      @setting.message_template_reporter
    end

    def variables
      last_reported = Report.by_place(@place).last
      {
        x_week: @setting.x_week,
        place_name: @place.name,
        last_reported: last_reported ? last_reported.called_at.strftime(Report::DEFAULT_DISPLAY_DATE_FORMAT) : 'unknown'
      }
    end
  end
end
