module Reports::Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    # from=2015-06-29&to=2015-07-14&phd=27&od=30&status=Listened
    def filter options
      reports = self.where('1=1')

      if options[:from].present?
        from = Date.strptime(options[:from], '%Y-%m-%d').to_time
        reports = reports.where(['called_at >= ?', from.beginning_of_day])
      end

      if options[:to].present?
        to = Date.strptime(options[:to], '%Y-%m-%d').to_time
        reports = reports.where(['called_at <= ?', to.end_of_day])
      end

      reports = reports.where(called_at: options[:last_day].to_i.day.ago.to_date..Date.today + 1.day) if options[:last_day].present?
      reports = reports.where(place_id: options[:place_id]) if options[:place_id].present?
      reports = reports.where(phd_id: options[:phd]) if options[:phd].present?
      reports = reports.where(od_id: options[:od]) if options[:od].present?
      reports = reports.where(reviewed: options[:reviewed]) if options[:reviewed].present?
      reports = reports.where(reviewed: true) if options[:state] === Report::REVIEWED

      if options[:week].present?
        week = Calendar::Week.parse(options[:week])
        reports = reports.where(year: week.year.number, week: week.week_number)
      end

      reports = reports.where(year: options[:year]) if options[:year].present? && options[:reviewed].to_i != Report::STATUS_NEW
      reports = reports.where("week >= ?", options[:from_week]) if options[:from_week].present? && options[:reviewed].to_i === Report::STATUS_REVIEWED
      reports = reports.where("week <= ?", options[:to_week]) if options[:to_week].present? && options[:reviewed].to_i === Report::STATUS_REVIEWED

      reports
    end
  end
end
