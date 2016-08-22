namespace :report do
  desc "Migrate place to report"
  task :migrate_user_place => :environment do
    reports = Report.where(place: nil).includes(:user)
    total_reports = reports.count
    log("Updating place in #{total_reports} reports") do
      reports.each_with_index do |report, i|
        print "\r Processing #{i + 1}/#{total_reports}"
        report.place = report.user.place
        report.save
      end
    end
  end

  desc "Audit reporter who is missing report in x week(s)"
  task :audit_missing => :environment do
    log("Audit reporter who is missing report in x week(s)") do
      auditor = Auditor::ReportMissingAuditor.new(Setting.report)
      auditor.audit
    end
  end
end

def log(message = "Starting task")
  started_at = Time.now

  print message
  yield if block_given?
  print "\nTask is done in #{Time.now - started_at} seconds."
end
