class EventsController < ApplicationController
  before_action :set_event, only: [:destroy]

  def index
    @events = Event.all.order('id DESC').includes(:attachments).page(params[:page])
  end

  def new
    @event = Event.new
    @event.attachments.build
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to events_path, notice: 'Event was successfully created'
    else
      @event.attachments.build if @event.attachments.empty?

      flash[:error] = attachment_error_messages
      render action: 'new'
    end
  end

  def destroy
    if @event.destroy
      redirect_to events_url, notice: 'Event was successfully removed'
    else
      redirect_to events_url, error: "Failed to remove event"
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :description, :from_date, :to_date, attachments_attributes: [:id, :event_id, :file])
  end

  def attachment_error_messages
    @event.errors.messages.map { |k, v| "#{k}: #{v.join(',')}" } if @event.errors.messages.count === 1 && @event.errors.messages.include?(:attachments)
  end

end
