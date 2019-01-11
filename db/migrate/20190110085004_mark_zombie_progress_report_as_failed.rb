class MarkZombieProgressReportAsFailed < ActiveRecord::Migration
  def change
    Report.after_last_sync.in_progress.find_in_batches(batch_size: 50) do |reports|
      Report.transaction do
        reports.each do |report|
          report.mark_as_failed
        end
      end
    end
  end
end
