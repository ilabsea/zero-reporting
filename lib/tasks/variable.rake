namespace :variable do
  desc 'Migrate alert_method'
  task :migrate_alert_method => :environment do
    Variable.migrate_alert_method
  end
end
