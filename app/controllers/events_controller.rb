class EventsController < ApplicationController
  authorize_resource

  before_action :set_event, only: [:destroy]

  def index
    @events = params[:type].presence ? Event.of_type(params[:type]) : Event.all
    @events = @events.includes(:attachments).page(params[:page])
    @events = EventDecorator.decorate_collection(@events)
  end

  def new
    @event = Event.new
    @event.attachments.build
  end

  def create
    @event = Event.new(event_params)

    begin
      @event.save!
      redirect_to events_url(type: Event::UPCOMING), notice: 'Event was successfully created'
    rescue ActiveRecord::RecordInvalid
      @event.attachments.build if @event.attachments.empty?

      flash[:error] = attachment_error_messages
      render action: 'new'
    end
  end

  def destroy
    begin
      @event.destroy
      redirect_to events_url(type: params[:type]), notice: 'Event was successfully removed'
    rescue ActiveRecord::StatementInvalid
      redirect_to events_url, alert: "Failed to remove event. Make sure there is no attachments associate to this event"
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:description, :display_from, :display_till, :ord, :is_enabled, :url_ref, attachments_attributes: [:id, :event_id, :file])
  end

  def attachment_error_messages
    @event.errors.messages.map { |k, v| "#{k}: #{v.join(',')}" } if @event.errors.messages.count === 1 && @event.errors.messages.include?(:attachments)
  end

end
