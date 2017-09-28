namespace :event do
  desc 'Migrate past events to disable'
  task :disable_past_event => :environment do
    Event.disable_past_event
  end
end
