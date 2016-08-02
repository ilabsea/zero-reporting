class EventDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def due_date
		if object.from_date === object.to_date or !object.to_date.present?
			object.from_date.to_s
		else
			object.from_date.to_s + " to " + object.to_date.to_s
		end
	end

end
