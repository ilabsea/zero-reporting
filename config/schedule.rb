every :day, :at => '8:00am' do
  rake 'report:audit_missing'
end

every 5.minutes do
  rake 'report:sync_calls'
end

every 1.day, :at => '12:00 am' do
  command "cd /var/www/cdc-zero-reporting-system/current && backup perform -t zero_backup -c /var/www/cdc-zero-reporting-system/current/lib/backup/config.rb"
end
