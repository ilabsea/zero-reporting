module Event::RequireField
  extend ActiveSupport::Concern

  included do
    has_many :attachments, class_name: 'EventAttachment', dependent: :destroy

    validates :description, presence: true
    validates :attachments, presence: true

    accepts_nested_attributes_for :attachments, allow_destroy: true, :reject_if => lambda { |e| e[:file].blank? }
  end

end
