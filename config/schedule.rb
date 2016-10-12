every :day, :at => '8:00am' do
  rake 'report:audit_missing'
end

every 5.minutes do
  rake 'report:sync_calls'
end
