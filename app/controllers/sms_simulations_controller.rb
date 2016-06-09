class SmsSimulationsController < ApplicationController
  def create
    places = Place.order(:ancestry)
    places = places.level(protected_params[:level]) if protected_params[:level].present?

    # select2 UI control comes with an additional empty string location
    places = places.in(protected_params[:locations]) if protected_params[:locations] && protected_params[:locations].reject(&:empty?).present?

    begin
      SmsSimulation.new(protected_params[:message]).simulate_to(User.members_of(places))
    rescue Errors::RecordNotFoundException => e
      redirect_to sms_simulations_path, alert: e.message
      return
    end

    redirect_to sms_simulations_path, notice: "SMS successfully broadcasted"
  end

  private
  def protected_params
    params.require(:sms_simulation).permit(:message, :level, :locations => [])
  end
end
