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

  factory :phd, class: Place do
    sequence(:name) {|n| "Place-#{n}"}
    sequence(:code) {|n| "0#{n}" }
    kind_of Place::Type::PHD
  end

  factory :od, class: Place do
    sequence(:name) {|n| "Place-#{n}"}
    sequence(:code) {|n| "0#{n}" }
    kind_of Place::Type::OD
    parent {create(:phd, code: "#{code}-1")}
  end

  factory :hc, class: Place do
    sequence(:name) {|n| "Place-#{n}"}
    sequence(:code) {|n| "0#{n}" }
    sequence(:dhis2_organisation_unit_uuid) {|n| "0#{n}" }
    kind_of Place::Type::HC
    parent{ create(:od, code: "#{code}-2")}
  end

end
