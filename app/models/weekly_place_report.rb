class WeeklyPlaceReport
  def initialize(week, place)
    @week = week
    @place = place
  end

  def reports
    Report.by_place(@place).reviewed_by_week(@week)
  end

  def total_value_by_variable(variable_id)
    reports.joins("INNER JOIN report_variables ON reports.id=report_variables.report_id")
    .where("report_variables.variable_id=?", variable_id).sum("report_variables.value")
  end

end
