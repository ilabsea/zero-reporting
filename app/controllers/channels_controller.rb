class ChannelsController < ApplicationController
  authorize_resource

  before_filter :set_channel, only: [:destroy, :mark_as_default, :state]
  def index
    @my_channels = current_user.channels.page(params[:page])
  end

  def new
    @channel = current_user.channels.build
  end

  def create
    @channel = current_user.channels.build(filter_params)
    #set the ticket_code only for android local gateway channel
    @channel.name = @channel.ticket_code if @channel.basic_setup?
    @channel.is_enable = true

    channel_nuntium = ChannelNuntium.new(@channel)
    if channel_nuntium.create
      current_user.channels.disable_other(@channel.id)
      redirect_to channels_path, notice: 'Channel has been created'
    else
      render json: channel_nuntium.error_message, status: 400, :layout => false
    end
  end

  def destroy
    channel_nuntium = ChannelNuntium.new(@channel)

    if channel_nuntium.delete
      redirect_to channels_path, notice: 'Channel has been deleted'
    else
      redirect_to channels_path, alert: 'Failed to delete channel'
    end
  end

  def mark_as_default
    @channel.mark_as_default

    redirect_to channels_path
  end

  def state
    @channel.update_state(params[:state])
    head :ok
  end

  private

  def set_channel
    @channel = current_user.channels.find(params[:id])
  end

  def filter_params
    params.require(:channel).permit(:name, :password, :ticket_code, :setup_flow)
  end
end
