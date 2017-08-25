namespace :user do
  desc 'Migrate reportable for users'
  task :migrate_reportable_user => :environment do
    UserMigration.migrate_reportable
  end
end
