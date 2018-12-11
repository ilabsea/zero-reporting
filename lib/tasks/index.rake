namespace :index do
  desc 'Index all reports to elasticsearch documents'
  task :recreate => :environment do
    abort('Settings elasticsearch is disabled') unless Settings.elasticsearch_enabled

    Report.transaction do
      Report.find_each(batch_size: 100) do |report|
        report.__elasticsearch__.index_document
        print '.'
      end

      puts
      puts 'index document for all reports successfully!'
    end
  end

  desc 'Index report to elasticsearch document by [id]'
  task :recreate_from, [:id] => :environment do |t, args|
    abort('Settings elasticsearch is disabled') unless Settings.elasticsearch_enabled

    report = Report.find(args[:id])
    report.__elasticsearch__.index_document

    puts "index document for report #{args[:id]} successfully!"
  end
end
