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

  def self.hub_enabled?
    ENV["HUB_ENABLED"] == '1'
  end

  def self.hub_configured?
    Setting[:hub_url].present? && Setting[:hub_email].present? && Setting[:hub_password].present? && Setting[:hub_task_name].present?
  end

end
