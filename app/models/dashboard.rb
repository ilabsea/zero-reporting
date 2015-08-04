class Dashboard

  def time_lines
    [
      {label: :today, from: Time.zone.now.beginning_of_day, to: Time.zone.now.end_of_day},
      {label: :this_week, from: Time.zone.now.beginning_of_week, to: Time.zone.now.end_of_week},
      {label: :last_week, from: Time.zone.now.beginning_of_week - 7.days, to: Time.zone.now.end_of_week - 7.days},
      {label: :last_2_weeks, from: Time.zone.now.beginning_of_week - 14.days, to: Time.zone.now.end_of_week - 14.days},
      {label: :this_month, from: Time.zone.now.beginning_of_month, to: Time.zone.now.end_of_month},
      {label: :this_year, from: Time.zone.now.beginning_of_year, to: Time.zone.now.end_of_year}
    ]
  end

  def time_line_for(label)
    time_lines.select{|time_line| time_line[:label] == label}.first
  end

  def get()


    results = []

    time_lines.each do |time_line|
      results << report_for(time_line)
    end
    results
  end



  def get_tabular
    reports = get
    results = [['New'],['Listened'],['Total']]
    reports.each do |result|
      results[0] << result[:new_report]
      results[1] << result[:listened_report]
      results[2] << result[:total]
    end
    results
  end

  def report_for time_line
    reports = Report.select('count(*) as number_of_report, listened')
                    .effective
                    .where(['called_at BETWEEN ? AND ? ', time_line[:from], time_line[:to]])
                    .group('listened')

    result = { label: time_line[:label],
               total: 0,
               listened_report: 0,
               new_report: 0,
               from: time_line[:from],
               to: time_line[:to]}

    reports.each do |report|
      if report.listened
        result[:listened_report] = report.number_of_report
      else
        result[:new_report] = report.number_of_report
      end
      result[:total] += report.number_of_report
    end

    result
  end


end
