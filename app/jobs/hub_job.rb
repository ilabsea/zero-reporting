class HubJob < ActiveJob::Base
  queue_as :hub

  def perform attributes
    url = Setting[:hub_url] || 'https://hub.instedd.org/'
    task = Setting[:hub_task_name] || 'zero_reporting_system'

    Service::Hub.instance(url).notify!(task, attributes)
  end
end
