# == Schema Information
#
# Table name: reports
#
#  id                         :integer          not null, primary key
#  phone                      :string(255)
#  user_id                    :integer
#  audio_key                  :string(255)
#  called_at                  :datetime
#  call_log_id                :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  phone_without_prefix       :string(255)
#  phd_id                     :integer
#  od_id                      :integer
#  status                     :string(255)
#  duration                   :float(24)
#  started_at                 :datetime
#  call_flow_id               :integer
#  recorded_audios            :text(65535)
#  has_audio                  :boolean          default(FALSE)
#  delete_status              :boolean          default(FALSE)
#  call_log_answers           :text(65535)
#  verboice_project_id        :integer
#  reviewed                   :boolean          default(FALSE)
#  year                       :integer
#  week                       :integer
#  reviewed_at                :datetime
#  is_reached_threshold       :boolean          default(FALSE)
#  dhis2_submitted            :boolean          default(FALSE)
#  dhis2_submitted_at         :datetime
#  dhis2_submitted_by         :integer
#  place_id                   :integer
#  verboice_sync_failed_count :integer          default(0)
#
# Indexes
#
#  index_call_failed_status        (call_log_id,verboice_sync_failed_count,status)
#  index_reports_on_place_id       (place_id)
#  index_reports_on_user_id        (user_id)
#  index_reports_on_year_and_week  (year,week)
#

FactoryGirl.define do
  factory :report do
    sequence(:phone) { |n| "100#{n}" }
    user
    called_at '2015-05-21 11:39:45'
    call_log_id 10
    reviewed false
    place
  end
end
