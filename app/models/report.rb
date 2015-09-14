# == Schema Information
#
# Table name: reports
#
#  id                   :integer          not null, primary key
#  phone                :string(255)
#  user_id              :integer
#  audio_key            :string(255)
#  listened             :boolean
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
#
# Indexes
#
#  index_reports_on_user_id  (user_id)
#

class Report < ActiveRecord::Base
  serialize :recorded_audios, Array
  serialize :call_log_answers, Array

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
    reports = reports.where(listened: options[:listened]) if options[:listened].present?
    reports
  end

  def self.create_from_call_log_id(call_log_id)
    verboice_attrs = Service::Verboice.connect(Setting).call_log(call_log_id)
    create_from_verboice_attrs(verboice_attrs.with_indifferent_access)
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
      listened: false
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

    report.update_attributes(attrs)
    report
  end
end
