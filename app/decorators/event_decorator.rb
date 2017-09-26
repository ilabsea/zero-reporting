class EventDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def due_date
		if object.display_from === object.display_till or !object.display_till.present?
			object.display_from.to_s
		else
			object.display_from.to_s + " to " + object.display_till.to_s
		end
	end

end
