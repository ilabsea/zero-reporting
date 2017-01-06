class EventAttachmentsController < ApplicationController
  authorize_resource
  
	before_action :set_event_attachment, only: [:download]

	def download
		send_file @event_attachment.absolute_path
	end

	private

	def set_event_attachment
		@event_attachment = EventAttachment.find(params[:id])
	end
end
