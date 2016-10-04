module Auditor
  class ReportMissingAuditor
    def initialize setting
      @setting = setting
    end

    def audit
      if @setting && @setting.has_enabled?
        if @setting.has_week?
          beginning_date_of_week = Calendar.beginning_date_of_week Date.today
          
          places = Place.missing_report_since(beginning_date_of_week - @setting.x_week.week)

          @setting.recipient_types.each do |place_type|
            auditor = Parser::PlaceAuditorParser.parse(place_type, places, @setting)
            auditor.audit
          end
        end
      end
    end
  end
end
