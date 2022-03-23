# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  var        :string(255)      not null
#  value      :text(65535)
#  thing_id   :integer
#  thing_type :string(30)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_settings_on_thing_type_and_thing_id_and_var  (thing_type,thing_id,var) UNIQUE
#

class Setting < RailsSettings::CachedSettings
  VERBOICE = :verboice
  HUB = :hub
  ALERT = :alert
  REPORT = :report
  TEMPLATE = :template
  TELEGRAM_BOT = :telegram_bot

  def self.hub_enabled?
    ENV['HUB_ENABLED'].present? && ENV['HUB_ENABLED'].to_i == 1
  end

  def self.hub_configured?
    Setting[:hub_url].present? && Setting[:hub_email].present? && Setting[:hub_password].present? && Setting[:hub_task_name].present?
  end

  def self.exceptional_years
    ENV['EXCEPTIONAL_YEAR'].present? ? ENV['EXCEPTIONAL_YEAR'].split(",").map(&:strip) : []
  end

  def self.wkst
    ENV['WKST'].present? ? ENV['WKST'].to_i : 0
  end
  
  def self.number_of_revise_week_available
    ENV['NUM_OF_REVISE_WEEK'].present? ? ENV['NUM_OF_REVISE_WEEK'].to_i : 1
  end
end
