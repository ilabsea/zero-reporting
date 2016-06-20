class ChannelNuntium
  attr_accessor :channel
  attr_accessor :error_message

  def initialize(channel)
    @channel = channel
    @nuntium = Sms::Nuntium.instance.nuntium
  end

  def create
    if @channel.valid?
      begin
        register_nuntium_channel if !@channel.global_setup?
        if !@channel.save
          @error_message = "Failed to save channel"
          return false
        end
        true
      rescue Nuntium::Exception => ex
        @error_message = ex.message
        false
      end
    else
      @error_message = "Failed to create channel invalid attributes"
      false
    end
  end

  def delete
    begin
      @channel.destroy!
    rescue Exception => ex
      return false
    end
    delete_nuntium_channel if !@channel.global_setup?
    true
  end

  def update
    if @channel.valid?
      begin
        update_nuntium_channel if !@channel.global_setup?
        if !@channel.save
          @error_message = "Failed to update channel"
          return false
        end
        true
      rescue Nuntium::Exception => ex
        @error_message = ex.message
      end
    else
      @error_message = "Failed to update channel"
      false
    end
  end

  def self.end_point
    ENV['NUNTIUM_HOST'] + '/' + ENV['NUNTIUM_ACCOUNT'] + '/qst'
  end

  def self.global_sms_channel
    [ { name: 'International Gateway(clickatell)', code: 'clickatell44911'},
     { name: 'Lao National Gateway(etl)', code: 'etl' },
     { name: 'Cambodia National Gateway(smart)', code: 'smart'},
     { name: "Cambodia National Gateway(mobitel)",code: 'camgsm'} ].map{|c| [c[:name], c[:code] ]}
  end

  def register_nuntium_channel
    config = {
      :name => @channel.name,
      :kind => 'qst_server',
      :protocol => 'sms',
      :direction => 'bidirectional',
      :enabled => true,
      :restrictions => '',
      :priority => 50,
      :configuration => {
        :password => @channel.gen_password,
        :friendly_name => @channel.name
      }
    }

    basic_options = { ticket_code: @channel.ticket_code,
                      ticket_message: "This phone will be used for as SMS gateway for #{ENV['APP_NAME']}." }


    config.merge!(basic_options) if @channel.basic_setup?
    response = @nuntium.create_channel(config)
    handle_nuntium_channel_response response
  end

  def update_nuntium_channel
    config_options = { name: @channel.name,
                       enabled: true,
                       restrictions: '',
                       configuration: {
                        friendly_name: @channel.name,
                        password: @channel.password
                       }
                     }
    response = @nuntium.update_channel(config_options)
    handle_nuntium_channel_response response
  end

  def handle_nuntium_channel_response(response)
    raise get_error_from_nuntium_response(response) if not response['name'] == @channel.name
    response
  end

  def get_error_from_nuntium_response(response)
    return "Error processing nuntium channel" if not response['summary']
    error = response['summary'].to_s
    unless response['properties'].blank?
      error << ': '
      error << response['properties'].map do |dict|
        dict.map{|k,v| "#{k} #{v}"}.join('; ')
      end.join('; ')
    end
    error
  end

  def delete_nuntium_channel
    @nuntium.delete_channel(@channel.name)
    true
  end

  def nuntium_info
    response = @nuntium.channel(@channel.name)
    @nuntium_info ||= handle_nuntium_channel_response(response)
  end

  def client_connected
    nuntium_info['connected'] rescue nil
  end

  def self.active_channels(channels)
    active_channels = []
    channels.each do |channel|
      if channel.is_enable && ChannelNuntium.new(channel).client_connected
        active_channels.push channel
      end
    end
    return active_channels
  end

end
