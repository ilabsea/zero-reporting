class Service::Hub

  def self.instance url
    @@instance ||= self.new(url)
  end

  def initialize url
    @url = url
  end

  def notify! task, attributes
    hub_task_url = "#{@url}/api/tasks/#{task}"
    begin
      post(hub_task_url, attributes)
    rescue
      raise "Can't connect to #{@url}"
    end
  end

  private

  def post(url, params)
    Typhoeus.post(url, body: JSON.generate({ form: { attributes: params } }), userpwd: "kakada@instedd.org:a1b2c3", headers: {'content-type' => 'application/json'} )
  end
end
