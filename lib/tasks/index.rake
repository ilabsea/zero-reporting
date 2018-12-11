namespace :index do
  desc 'Migrate all reports to elasticsearch documents'
  task :recreate => :environment do
    return unless Settings.elasticsearch_enabled

    Report.transaction do
      Report.find_each(batch_size: 100) do |report|
        report.__elasticsearch__.index_document
        print '.'
      end

      puts
      puts 'index document for all reports successfully!'
    end
  end

  desc 'Migrate report to elasticsearch document by [id]'
  task :recreate_from, [:id] => :environment do |t, args|
    return unless Settings.elasticsearch_enabled

    report = Report.where(id: args[:id]).first
    return if report.nil?

    report.__elasticsearch__.index_document

    puts "index document for report #{args[:id]} successfully!"
  end
end
