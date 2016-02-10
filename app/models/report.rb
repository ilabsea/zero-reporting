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
#
# Indexes
#
#  index_reports_on_user_id        (user_id)
#  index_reports_on_year_and_week  (year,week)
#

class Report < ActiveRecord::Base
  serialize :recorded_audios, Array
  serialize :call_log_answers, Array

  audited

  belongs_to :user

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

  before_save :normalize_attrs

  def normalize_attrs
    self.phone_without_prefix = Tel.new(self.phone).without_prefix if self.phone.present?
    if self.user && self.user.place
      self.phd = self.user.place.phd
      self.od  = self.user.place.od
    end
  end

  def self.effective
    where(delete_status: false)
  end

  def self.week_between from, to
    where("week >= ? and week <= ?", from, to)
  end

  # from=2015-06-29&to=2015-07-14&phd=27&od=30&status=Listened
  def self.filter options
    reports = self.where('1=1')

    if options[:from].present?
      from = Date.strptime(options[:from], '%Y-%m-%d').to_time
      reports = reports.where(['called_at >= ?', from.beginning_of_day ])
    end

    if options[:to].present?
      to = Date.strptime(options[:to], '%Y-%m-%d').to_time
      reports = reports.where(['called_at <= ?', to.end_of_day ])
    end

    reports = reports.where(phd_id: options[:phd]) if options[:phd].present?
    reports = reports.where(od_id: options[:od]) if options[:od].present?
    reports = reports.where(reviewed: options[:reviewed]) if options[:reviewed].present?
    reports = reports.where(year: options[:year]) if options[:year].present? && options[:reviewed].to_i != STATUS_NEW

    reports = reports.where("week >= ?", options[:from_week]) if options[:from_week].present? && options[:reviewed].to_i == STATUS_REVIEWED
    reports = reports.where("week <= ?", options[:to_week]) if options[:to_week].present? && options[:reviewed].to_i == STATUS_REVIEWED

    reports
  end

  def self.create_from_call_log_id(call_log_id)
    verboice_attrs = Service::Verboice.connect(Setting).call_log(call_log_id)
    user = User.find_by(phone_without_prefix: Tel.new(verboice_attrs.with_indifferent_access[:address]).without_prefix)
    if user
      create_from_verboice_attrs(verboice_attrs.with_indifferent_access)
    end
  end

  def self.create_from_verboice_attrs verboice_attrs
    attrs = {
      verboice_project_id: verboice_attrs[:project][:id],
      phone: verboice_attrs[:address],
      duration: verboice_attrs[:duration],
      called_at: verboice_attrs[:called_at],
      started_at: verboice_attrs[:started_at],
      call_log_id: verboice_attrs[:id],
      call_flow_id: verboice_attrs[:call_flow_id],
      recorded_audios: verboice_attrs[:call_log_recorded_audios],
      call_log_answers: verboice_attrs[:call_log_answers],
      reviewed: false
    }

    verboice_attrs[:call_log_recorded_audios].each do |recorded_audio|
      if recorded_audio[:project_variable_id] == Setting[:project_variable].to_i
        attrs[:audio_key] = recorded_audio[:key]
        break
      else
      end
    end

    variables = Variable.where(verboice_project_id: verboice_attrs[:project][:id])

    attrs[:user] = User.find_by(phone_without_prefix: Tel.new(verboice_attrs[:address]).without_prefix)
    report = Report.where(call_log_id: attrs[:call_log_id]).first_or_initialize

    verboice_attrs[:call_log_recorded_audios].each do |recorded_audio|
      variable = variables.select{|variable| variable.verboice_id == recorded_audio[:project_variable_id]}.first
      report.report_variable_audios.build( value: recorded_audio[:key], variable_id: variable.id) if variable
    end

    verboice_attrs[:call_log_answers].each do |call_log_answer|
      variable = variables.select{|variable| variable.verboice_id == call_log_answer[:project_variable_id]}.first
      report.report_variable_values.build(value: call_log_answer[:value], variable_id: variable.id) if variable
    end
    report.check_threshold
    report.update_attributes(attrs)
    report
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
      p colour
      name = "Unknown PHD"
      if key
        percentage = sprintf( "%0.02f", (100 * value.to_f / reports.size.to_f))
        place = Place.find_by_id(key)
        name = place.name
      else
        percentage = sprintf( "%0.02f", (100 * value.to_f / reports.size.to_f))
      end
      list.push({ label: "#{name}(#{percentage}%)",  data: percentage, color: "##{colour}"})
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

  def check_threshold
    date = self.called_at.to_date
    week = Calendar.week_number(date)
    year = date.year
    self.report_variables.each do |report_variable|
      threshold = report_variable.variable.threshold_by_year_week(year, week)
      if report_variable.value.to_i >= threshold
        p "is_reached_threshold #{report_variable.variable.name}"
        report_variable.mark_as_reaching_threshold
      else
        p "#{report_variable.variable.name}"
        report_variable.unmark_as_reaching_threshold
      end
    end
  end
end
