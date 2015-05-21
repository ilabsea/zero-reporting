FactoryGirl.define do
  factory :report do
    phone_number "MyString"
    user
    audio "MyString"
    listened false
    called_at "2015-05-21 11:39:45"
    call_log_id 10
  end
end
