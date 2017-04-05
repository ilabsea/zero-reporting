FactoryGirl.define do
  factory :report_variable_value do
    report nil
    variable nil
    type "ReportVariableValue"
    is_alerted false
  end

end
