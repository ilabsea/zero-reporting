# == Schema Information
#
# Table name: variables
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  description             :string(255)
#  verboice_id             :integer
#  verboice_name           :string(255)
#  verboice_project_id     :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  background_color        :string(255)
#  text_color              :string(255)
#  is_alerted_by_threshold :boolean          default(TRUE)
#  is_alerted_by_report    :boolean          default(FALSE)
#  dhis2_data_element_uuid :string(255)
#  disabled                :boolean          default(FALSE)
#  alert_method            :string(255)      default("none")
#

class Variable < ActiveRecord::Base
  validates :verboice_id, uniqueness: {scope: :verboice_project_id, message: 'variable has already been taken' }

  has_many :report_variables, dependent: :nullify
  has_many :reports, through: :report_variables
  has_many :report_variable_audios
  has_many :report_variable_values

  ALERT_METHODS = { 
    none: 'None',
    formula: "If the value is greater than the threshold, <b>#{ENV['THRESHOLD_FORMULA']}</b>",
    case_base: 'If the value is greater than 0'
  }

  VALID_ALERT_METHOD = ['formula', 'case_base']

  def self.applied(project_id)
    where(verboice_project_id: project_id)
  end

  def total_report_value(report_ids)
    report_variable_values.where(report_id: report_ids).sum(:value).to_i
  end

  def total_report_value_by_week(week)
    reports = Report.reviewed_by_week(week)
    total_report_value(reports.map(&:id))
  end

  def threshold_by_place_and_week(place, week)
    threshold = 0.0
    (1..ENV['THRESHOLD_WEEK_RANGE'].to_i).each do |i|
      week_previous = week.previous
      threshold = threshold + WeeklyPlaceReport.new(week_previous, place).total_value_by_variable(self.id)
      week = week_previous
    end
    (threshold/ENV['THRESHOLD_WEEK_RANGE'].to_i)*1.5
  end

  def has_alert_method?
    VALID_ALERT_METHOD.include? alert_method
  end

  def self.migrate_alert_method
    Variable.transaction do
      Variable.find_each(batch_size: 100) do |variable|
        variable.alert_method = variable.is_alerted_by_threshold ? :formula : :case_base
        variable.save
      end
    end
  end

end
