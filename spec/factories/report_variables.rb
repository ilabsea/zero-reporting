# == Schema Information
#
# Table name: report_variables
#
#  id          :integer          not null, primary key
#  report_id   :integer
#  variable_id :integer
#  type        :string(255)
#  value       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  has_audio   :boolean          default(FALSE)
#  listened    :boolean          default(FALSE)
#
# Indexes
#
#  index_report_variables_on_report_id    (report_id)
#  index_report_variables_on_variable_id  (variable_id)
#

FactoryGirl.define do
  factory :report_variable do
    report nil
variable nil
type ""
  end

end
