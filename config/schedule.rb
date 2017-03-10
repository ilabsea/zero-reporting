every :day, :at => '8:00am' do
  rake 'report:audit_missing'
end

every 5.minutes do
  rake 'report:sync_calls'
end

every 1.day, :at => '10:30 am' do
  command "backup perform -t zero_backup"
end
