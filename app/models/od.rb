class OD < Place
	def self.model_name
    Place.model_name
  end

	def child_type
		HC.kind
	end

	def child_allowed?
		true
	end
end
