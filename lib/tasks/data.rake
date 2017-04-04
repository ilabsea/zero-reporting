task :environment

namespace :data do
  desc "Restore data from sql files"
  task :restore, [:s3_object_key] => :environment do |task, args|
    Backup::Data.new(args[:s3_object_key]).restore
  end

end
