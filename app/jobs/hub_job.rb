class HubJob < ActiveJob::Base
  queue_as :hub

  def perform attributes
    url = Setting[:hub_url] || 'https://hub.instedd.org/'
    email = Setting[:hub_email] || ''
    password = Setting[:hub_password] || ''
    task = Setting[:hub_task_name] || 'zero_reporting_system'

    Service::Hub.connect(url, email, password).notify!(task, attributes)
  end
end
