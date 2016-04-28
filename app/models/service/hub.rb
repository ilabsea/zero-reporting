class Service::Hub

  def self.connect url, email, password
    @@instance ||= self.new(url, email, password)
  end

  def initialize url, email, password
    @url = url
    @email = email
    @password = password
  end

  def notify! task, attributes
    uri = build_uri("api/tasks/#{task}")
    begin
      post(uri, attributes)
    rescue
      raise "Can't connect to #{@url}"
    end
  end

  private

  def post(uri, params)
    Typhoeus.post(uri, body: JSON.generate(params), userpwd: "#{@email}:#{@password}", headers: {'content-type' => 'application/json'} )
  end

  def build_uri(path)
    URI.join(@url, path)
  end
end
