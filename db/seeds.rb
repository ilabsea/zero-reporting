# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Default user

user_attrs = { username: 'admin', password: '123456', name: 'Admin' }

user = User.where(username: user_attrs[:username]).first_or_initialize
user.update_attributes(user_attrs)

phd_attrs = [
  { name: "KampongCham", code: "01" },
  { name: "Tbong Khum", code: "02" },
  { name: "Phnom penh", code: "03" },
]

phd_attrs.each do |phd_attr|
  phd = Phd.where(code: phd_attr[:code]).first_or_initialize
  phd.update_attributes(phd_attr)
end