task :environment

namespace :data do
  desc "Restore data from sql files"
  task :restore, [:directory] => :environment do |task, args|

  end

end
