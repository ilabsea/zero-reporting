namespace :index do
  desc 'Index all reports to elasticsearch documents'
  task :recreate => :environment do
    abort('Settings elasticsearch is disabled') unless Settings.elasticsearch_enabled

    Report.transaction do
      index = 0
      count = Report.count

      Report.find_each(batch_size: 100) do |report|
        report.__elasticsearch__.index_document

        index += 1
        percentage = (index / count.to_f * 100).round
        recycle_console
        print "\rIndex reports document, total #{count}, done #{percentage}%"
      end

      puts
    end
  end

  desc 'Index reports to elasticsearch documents start from [current id]'
  task :recreate_from, [:id] => :environment do |t, args|
    abort('Settings elasticsearch is disabled') unless Settings.elasticsearch_enabled

    Report.transaction do
      index = 0
      count = Report.where('id >= ?', args[:id]).count

      Report.find_each(start: args[:id], batch_size: 100) do |report|
        report.__elasticsearch__.index_document

        index += 1
        percentage = (index / count.to_f * 100).round
        recycle_console
        print "\rIndex reports document start from id (#{args[:id]}), total #{count}, done #{percentage}%"
      end

      puts
    end
  end

  def recycle_console
    print "\r#{' ' * 120}"
  end
end
