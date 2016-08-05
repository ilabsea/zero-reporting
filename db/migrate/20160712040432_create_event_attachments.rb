class CreateEventAttachments < ActiveRecord::Migration
  def change
    create_table :event_attachments do |t|
      t.string :file
      t.integer :event_id

      t.timestamps null: false
    end

    add_index :event_attachments, :event_id
  end
end
