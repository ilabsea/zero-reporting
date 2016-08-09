class HC < Place
	def self.model_name
    Place.model_name
  end

  def child_type
		nil
	end
  
	def child_allowed?
		false
	end

	def new_child
		raise "Health Center #{name} is not allowed to have child"
	end
end
