class AddForeignKeyEventToEventAttachments < ActiveRecord::Migration
  def change
  	add_foreign_key :event_attachments, :events
  end
end
