# == Schema Information
#
# Table name: places
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  code                         :string(255)
#  kind_of                      :string(255)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  ancestry                     :string(255)
#  dhis2_organisation_unit_uuid :string(255)
#  auditable                    :boolean          default(TRUE)
#
# Indexes
#
#  index_places_on_ancestry  (ancestry)
#

FactoryGirl.define do
  factory :place do
    sequence(:name) {|n| "Place-#{n}"}
    sequence(:code) {|n| "0#{n}" }
    kind_of Place::Type::PHD
  end

  factory :phd, class: PHD do
    sequence(:name) {|n| "Place-#{n}"}
    sequence(:code) {|n| "phd_0#{n}" }
  end

  factory :od, class: OD do
    sequence(:name) {|n| "Place-#{n}"}
    sequence(:code) {|n| "od_0#{n}" }
    parent {create(:phd, code: "#{code}-1")}
  end

  factory :hc, class: HC do
    sequence(:name) {|n| "Place-#{n}"}
    sequence(:code) {|n| "hc_0#{n}" }
    sequence(:dhis2_organisation_unit_uuid) {|n| "0#{n}" }
    parent{ create(:od, code: "#{code}-2")}
  end

end
