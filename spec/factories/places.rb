FactoryGirl.define do
  factory :place do
    sequence(:name) {|n| "Place-#{n}"}
    sequence(:code) {|n| "0#{n}" }
    kind_of Place::PLACE_TYPE_PHD
  end

  factory :phd, class: Place do
    sequence(:name) {|n| "Place-#{n}"}
    sequence(:code) {|n| "0#{n}" }
    kind_of Place::PLACE_TYPE_PHD
  end

  factory :od, class: Place do
    sequence(:name) {|n| "Place-#{n}"}
    sequence(:code) {|n| "0#{n}" }
    kind_of Place::PLACE_TYPE_OD
    parent {create(:phd, code: "#{code}-1")}
  end

  factory :hc, class: Place do
    sequence(:name) {|n| "Place-#{n}"}
    sequence(:code) {|n| "0#{n}" }
    kind_of Place::PLACE_TYPE_HC
    parent{ create(:od, code: "#{code}-2")}
  end

end
