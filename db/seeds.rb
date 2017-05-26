# Default user
user_attrs = { username: 'admin', password: '123456', name: 'Admin', role: User::ROLE_ADMIN }

user = User.where(username: user_attrs[:username]).first_or_initialize
user.update_attributes(user_attrs)

# Log type
alert_log_type = LogType.where(name: :alert, kind: :sms).first_or_initialize
if alert_log_type.new_record?
  alert_log_type.description = 'Alert SMS message when report reaches threshold'
  alert_log_type.save
end

broadcast_log_type = LogType.where(name: :broadcast, kind: :sms).first_or_initialize
if broadcast_log_type.new_record?
  broadcast_log_type.description = 'Broadcast SMS message'
  broadcast_log_type.save
end

notify_log_type = LogType.where(name: :notify, kind: :sms).first_or_initialize
if notify_log_type.new_record?
  notify_log_type.description = 'SMS notify supervisor when caller left voice record'
  notify_log_type.save
end

reminder_log_type = LogType.where(name: :reminder, kind: :sms).first_or_initialize
if reminder_log_type.new_record?
  reminder_log_type.description = 'SMS notify supervisor and remind health center when report was missing in x week(s)'
  reminder_log_type.save
end

reminder_call_log_type = LogType.where(name: :reminder_call, kind: :voice).first_or_initialize
if reminder_call_log_type.new_record?
  reminder_call_log_type.description = 'Call remind health center when report was missing in x week(s)'
  reminder_call_log_type.save
end

report_confirmation_type = LogType.where(name: :report_confirmation, kind: :sms).first_or_initialize
if report_confirmation_type.new_record?
  report_confirmation_type.description = 'SMS confirmation to health center on the successful report'
  report_confirmation_type.save
end
