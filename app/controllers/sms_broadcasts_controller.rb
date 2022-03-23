class SmsBroadcastsController < ApplicationController
  authorize_resource
  
  def create
    places = Place.order(:ancestry)
    places = places.level(protected_params[:level]) if protected_params[:level].present?

    # select2 UI control comes with an additional empty string location
    places = places.in(protected_params[:locations]) if protected_params[:locations] && protected_params[:locations].reject(&:empty?).present?

    begin
      SmsBroadcast.new(protected_params[:message]).broadcast_to(User.members_of(places))
      # TelegramBroadcast.new(protected_params[:message]).broadcast_to(User.members_of(places))
    rescue Nuntium::Exception => e
      redirect_to sms_broadcasts_path, alert: e.message
      return
    end

    redirect_to sms_broadcasts_path, notice: "SMS successfully broadcasted"
  end

  private
  
  def protected_params
    params.require(:sms_broadcast).permit(:message, :level, :locations => [])
  end
end
