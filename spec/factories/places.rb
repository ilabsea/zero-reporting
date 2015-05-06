FactoryGirl.define do
  factory :place do
    sequence(:name) {|n| "Place-#{n}"}
    sequence(:code) {|n| "0#{n}" }
    kind_of Place::PLACE_TYPE_PHD
  end
end
