FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "user_#{n}"}
    password "1234567"
    name "Reminder"
    sequence(:phone) {|n| "012012345#{n}"}
    place { create(:place, )}
  end

end
