# == Schema Information
#
# Table name: event_attachments
#
#  id         :integer          not null, primary key
#  file       :string(255)
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_event_attachments_on_event_id  (event_id)
#

class EventAttachment < ActiveRecord::Base
	mount_uploader :file, FileUploader

	belongs_to :event

	def absolute_path
		File.join(Rails.root, 'public', file_url)
	end

	def filename
		file.file.filename + (file.file.filename.include?(".") ? "" : ".#{file.content_type.split("/").last}")
	end

end
