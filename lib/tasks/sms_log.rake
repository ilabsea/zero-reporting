namespace :sms_log do
  desc "Set every log as alert for undefined"
  task :mark_undefined_as_alert => :environment do
    undefined_logs = SmsLog.where(type: nil)
    log("Updating #{undefined_logs.count} undefined sms log to alert") do
      undefined_logs.find_each do |log|
        log.type = SmsType.alert
        log.save
      end
    end
  end
end

def log(message = "Starting task")
  started_at = Time.now

  print message
  yield if block_given?
  print "\nTask is done in #{Time.now - started_at} seconds."
end
