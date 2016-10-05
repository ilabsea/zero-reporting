# == Schema Information
#
# Table name: reports
#
#  id                   :integer          not null, primary key
#  phone                :string(255)
#  user_id              :integer
#  audio_key            :string(255)
#  called_at            :datetime
#  call_log_id          :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  phone_without_prefix :string(255)
#  phd_id               :integer
#  od_id                :integer
#  status               :string(255)
#  duration             :float(24)
#  started_at           :datetime
#  call_flow_id         :integer
#  recorded_audios      :text(65535)
#  has_audio            :boolean          default(FALSE)
#  delete_status        :boolean          default(FALSE)
#  call_log_answers     :text(65535)
#  verboice_project_id  :integer
#  reviewed             :boolean          default(FALSE)
#  year                 :integer
#  week                 :integer
#  reviewed_at          :datetime
#  is_reached_threshold :boolean          default(FALSE)
#  dhis2_submitted      :boolean          default(FALSE)
#  dhis2_submitted_at   :datetime
#  dhis2_submitted_by   :integer
#  place_id             :integer
#
# Indexes
#
#  index_reports_on_place_id       (place_id)
#  index_reports_on_user_id        (user_id)
#  index_reports_on_year_and_week  (year,week)
#

class Report < ActiveRecord::Base
  include Reports::Filterable

  serialize :recorded_audios, Array
  serialize :call_log_answers, Array

  audited

  belongs_to :user
  belongs_to :place

  belongs_to :phd, class_name: 'Place', foreign_key: 'phd_id'
  belongs_to :od, class_name: 'Place', foreign_key: 'od_id'

  has_many :report_variables
  has_many :report_variable_audios
  has_many :report_variable_values

  has_many :variables, through: :report_variables

  VERBOICE_CALL_STATUS_FAILED = 'failed'
  VERBOICE_CALL_STATUS_COMPLETE = 'complete'
  VERBOICE_CALL_STATUS_IN_PROGRESS = 'in-progress'

  STATUS_NEW = 0
  STATUS_REVIEWED = 1

  NEW = 'new'
  REVIEWED = 'reviewed'

  DEFALUT_DISLAY_IN_LAST_DAY = 3
  DEFAULT_DISPLAY_DATE_FORMAT = '%a %d-%m-%y %H:%M' # Tue 30-12-2016 10:00

  before_save :normalize_attrs
  before_save :set_place_tree

  def normalize_attrs
    self.phone_without_prefix = Tel.new(self.phone).without_prefix if self.phone.present?
  end

  def set_place_tree
    if self.user && self.user.place
      self.place = self.user.place
      self.phd = self.user.place.phd
      self.od  = self.user.place.od
    end
  end

  def self.effective
    where(delete_status: false)
  end

  def self.reviewed_by_week week
    where("year = ? AND week = ? AND reviewed = ?", week.year.number, week.week_number, STATUS_REVIEWED)
  end

  def self.week_between from, to
    where("week >= ? and week <= ?", from, to)
  end

  def self.by_place place
    user_ids = place.users.pluck(:id)
    Report.where(user_id: user_ids)
  end


  def self.create_from_call_log_id_with_status(call_log_id, status)
    verboice_attrs = Service::Verboice.connect(Setting).call_log(call_log_id)
    user = User.find_by_address(verboice_attrs.with_indifferent_access[:address])
    if user && user.hc_worker?
      report = Parser::ReportParser.parse(verboice_attrs.with_indifferent_access)
      report.status = status
      if report.save
        report.alert if report.success?
        report
      end
    end
  end

  def self.create_from_call_log_id(call_log_id)
    verboice_attrs = Service::Verboice.connect(Setting).call_log(call_log_id)
    user = User.find_by_address(verboice_attrs.with_indifferent_access[:address])
    if user && user.hc_worker?
      report = Parser::ReportParser.parse(verboice_attrs.with_indifferent_access)
      if report.save
        report.alert
        report
      end
    end
  end

  def toggle_status
    self.reviewed = !self.reviewed
    self.save
  end

  def reviewed_as! year, week
    self.reviewed = true
    self.reviewed_at = Time.now
    self.year = year
    self.week = week
    self.save!
  end

  def self.to_piechart_reviewed(reports)
    not_reviewed = reports.where("reviewed = ?", false).size
    reviewed = reports.where("reviewed = ?", true).size
    percentage_reviewed = sprintf( "%0.02f", (100 * reviewed.to_f / reports.size.to_f))
    percentage_not_reviewed = sprintf( "%0.02f", (100 * not_reviewed.to_f / reports.size))
    return [{ label: "Report Reviewed(#{percentage_reviewed}%)",  data: percentage_reviewed, color: "#68BC31"}, { label: "Report Not Reviewed(#{percentage_not_reviewed}%)",  data: percentage_not_reviewed, color: "#2091CF"}]
  end

  def self.to_piechart_phd(reports)
    summary = reports.group(:phd_id).size
    list = []
    summary.each do |key, value|
      colour = generate_color
      name = "Unknown PHD"
      if key
        percentage = sprintf( "%0.02f", (100 * value.to_f / reports.size.to_f))
        place = Place.find_by_id(key)
        name = place.name
      else
        percentage = sprintf( "%0.02f", (100 * value.to_f / reports.size.to_f))
      end
      list.push({ label: "#{name}(#{percentage}%)",  data: percentage, color: "##{colour}" })
    end
    return list
  end

  def self.generate_color
    r = rand(255).to_s(16)
    g = rand(255).to_s(16)
    b = rand(255).to_s(16)

    r, g, b = [r, g, b].map { |s| if s.size == 1 then '0' + s else s end }

    color = r + g + b
  end

  def alert
    alert_setting = AlertSetting.find_by(verboice_project_id: self.verboice_project_id)
    
    return unless alert_setting

    week = self.week_for_alert
    place = self.place

    self.report_variable_values.each do |report_variable|
      report_variable.check_alert_by_week(week, place)
    end

    self.weekly_notify(week,alert_setting)
  end

  def week_for_alert
    week = Calendar.week(self.called_at.to_date)

    # shift 1 week back if the report is on sunday or after wednesday
    if self.called_at.to_date.wday > 3 || self.called_at.to_date.wday == 0
       return week.previous
    end

    return week
  end

  def weekly_notify(week, alert_setting)
    alert = Alerts::ReportCaseAlert.new(alert_setting, self, week)
    adapter = Adapter::SmsAlertAdapter.new(alert)
    adapter.process
  end

  def alerted_variables
    self.report_variables.where(is_alerted: true).joins(:variable).select("report_variables.*, variables.name")
  end

  def notify_hub!
    HubJob.perform_later(to_hub_parameters) if Setting.hub_enabled? && Setting.hub_configured?
  end

  def to_hub_parameters
    params = {
      period: "#{year}W#{format('%02d', week)}",
      completeDate: Date.today.to_s
    }

    params[:orgUnit] = user.place.hc.dhis2_organisation_unit_uuid if user.place.hc.dhis2_organisation_unit_uuid

    report_variables.each do |report_variable|
      params.merge!(report_variable.to_hub_parameters) if report_variable.value
    end

    params
  end

  def self.audit_missing
    report_setting = Setting.report
    if report_setting.has_day?(Date.today.wday)
      auditor = Auditor::ReportMissingAuditor.new(report_setting)
      auditor.audit
    end
  end

  def failed?
    status === VERBOICE_CALL_STATUS_FAILED
  end

  def in_progress?
    status === VERBOICE_CALL_STATUS_IN_PROGRESS
  end

  def success?
    status === VERBOICE_CALL_STATUS_COMPLETE
  end

  def status_info
    return { color: 'red', text: 'Failed' } if failed?
    return { color: 'orange', text: 'In-progress' } if in_progress?
    
    { color: 'green', text: 'Success' }
  end
end
