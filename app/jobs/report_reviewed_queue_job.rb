class ReportReviewedQueueJob < ActiveJob::Base
  queue_as ENV['DEFAULT_QUEUE_NAME']

  def perform(report, reportReviewedSetting)
    reportReviewedSetting.notify(report)
  end
end
