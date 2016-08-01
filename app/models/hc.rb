class HC < Place
	def self.model_name
    Place.model_name
  end
  
	def child_allowed?
		false
	end
end
