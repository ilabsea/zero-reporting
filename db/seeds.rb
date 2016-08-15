# Default user
user_attrs = { username: 'admin', password: '123456', name: 'Admin', role: User::ROLE_ADMIN }

user = User.where(username: user_attrs[:username]).first_or_initialize
user.update_attributes(user_attrs)

# Sms type
alert_sms_type = SmsType.where(name: :alert).first_or_initialize
if alert_sms_type.new_record?
  alert_sms_type.description = 'Alert message when report reaches threshold'
  alert_sms_type.save
end

broadcast_sms_type = SmsType.where(name: :broadcast).first_or_initialize
if broadcast_sms_type.new_record?
  broadcast_sms_type.description = 'Broadcast message'
  broadcast_sms_type.save
end

verboice_sms_type = SmsType.where(name: :verboice).first_or_initialize
if verboice_sms_type.new_record?
  verboice_sms_type.description = 'Verboice message when caller left voice record'
  verboice_sms_type.save
end

# phd_attrs = [
#   { name: "KampongCham", code: "01" },
#   { name: "Tbong Khum", code: "02" },
#   { name: "Phnom penh", code: "03" },
# ]

# phd_attrs.each do |phd_attr|
#   phd = Phd.where(code: phd_attr[:code]).first_or_initialize
#   phd.update_attributes(phd_attr)
# end
