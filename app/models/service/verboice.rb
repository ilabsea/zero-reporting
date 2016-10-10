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

  def call(call)
    unless call.receivers.empty?
      bulk_call call.to_verboice_calls

      Log.write_call(call)
    end
  end

  def bulk_call(calls)
    return if calls.empty?

    post('/bulk_call', { call: calls })
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

  def project_call_flows project_id
    call_flows.select { |c| c['project_id'] === project_id.to_i }
  end

  def call_log(id)
    get("/call_logs/#{id}")
  end

  def call_logs(ids)
    get("/call_logs?id=#{ids.join(',')}")
  end

  def call_log_audio(report_variable)
    url = build_url("/call_logs/#{report_variable.report.call_log_id}/play_audio?key=#{report_variable.value}")
    Rails.logger.debug("fetching resource from: #{url}")

    audio_file = File.open report_variable.audio_data_path, 'wb'
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
