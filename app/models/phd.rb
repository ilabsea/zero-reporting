class PHD < Place
	def self.model_name
    Place.model_name
  end
  
	def child_type
		OD.kind
	end

	def child_allowed?
		true
	end
end
