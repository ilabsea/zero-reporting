# == Schema Information
#
# Table name: report_variables
#
#  id           :integer          not null, primary key
#  report_id    :integer
#  variable_id  :integer
#  type         :string(255)
#  value        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  has_audio    :boolean          default(FALSE)
#  listened     :boolean          default(FALSE)
#  token        :string(255)
#  is_alerted   :boolean          default(FALSE)
#  exceed_value :string(255)
#
# Indexes
#
#  index_report_variables_on_report_id                           (report_id)
#  index_report_variables_on_report_id_and_variable_id_and_type  (report_id,variable_id,type)
#  index_report_variables_on_variable_id                         (variable_id)
#

class ReportVariable < ActiveRecord::Base
  has_secure_token

  belongs_to :report
  belongs_to :variable

  def mark_as_reaching_alert
    self.is_alerted = true
    self.save
  end

  def mark_as_reaching_alert_with_exceed_value(value)
    self.is_alerted = true
    self.exceed_value = value
    self.save
  end

  def unmark_as_reaching_alert
    self.is_alerted = false
    self.save
  end

  def check_alert_for(week, place)
    strategy = Strategies::ThresholdStrategy.get(self.variable.alert_method)
    self.set_alert(strategy, week, place)
  end

  def has_value?
    value.present?
  end

  def alert_defined?
    variable.has_alert_method? && has_value?
  end

  def set_alert(strategy, week, place)
    context = ThresholdContext.new(strategy)
    context.baseline_of(self.variable, place, week) do |threshold|
      exceed_value = self.value.to_i - threshold.value
      exceed_value > 0 ? self.mark_as_reaching_alert_with_exceed_value(exceed_value) : self.unmark_as_reaching_alert
    end
  end

  def to_hub_parameters
    variable && variable.dhis2_data_element_uuid ? {variable.dhis2_data_element_uuid => value} : {}
  end

end
