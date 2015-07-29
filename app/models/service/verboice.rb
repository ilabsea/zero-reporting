class Service::Verboice

  def self.auth email, password
    auth_url = "#{ENV['VERBOICE_URL']}/auth"
    response = Typhoeus.post(auth_url, body: { account: { email: email, password: password } })
    response.success? ? JSON.parse(response.body) : nil
  end

  def self.connect data_source
    @@instance ||= self.new(data_source[:verboice_email], data_source[:verboice_token])
  end

  def initialize(email, token)
    @email = email
    @token = token
  end

  def channels
    get('/channels')
  end

  def projects
    get('/projects')
  end

  def call_flows
    get('/call_flows')
  end

  def call_log(id)
    get("/call_logs/#{id}")
  end

  def call_log_audio(report)
    url = build_url("/call_logs/#{report.call_log_id}/play_audio?key=#{report.audio_key}")

    audio_file = File.open report.audio_data_path, 'wb'
    request = Typhoeus::Request.new(url, method: :get, params: auth_params )

    request.on_headers do |response|
      if response.code != 200
        raise "Request failed"
      end
    end

    request.on_body do |chunk|
      audio_file.write(chunk)
    end

    request.on_complete do |response|
      audio_file.close
    end
    request.run
  end

  def schedules(project_id)
    get("/projects/#{project_id}/schedules")
  end

  def project_variables(project_id)
    get("/project_variables?project_id=#{project_id}")
  end

  private

  def get(path)
    response = Typhoeus.get( build_url(path), body: JSON.generate(auth_params), headers: {'content-type' => 'application/json'} )
    JSON.parse(response.response_body)
  end

  def post(path, params)
    Typhoeus.post(build_url(path), body: JSON.generate(auth_params(params)), headers: {'content-type' => 'application/json'} )
  end

  def build_url(path)
    ENV['VERBOICE_URL'] + path
  end

  def auth_params(params = {})
    params.merge({ email: @email, token: @token })
  end
end
