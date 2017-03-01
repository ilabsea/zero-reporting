class OD < Place
	def self.model_name
    Place.model_name
  end

  def parent_type
    PHD.kind
  end

	def child_type
		HC.kind
	end

	def child_allowed?
		true
	end

  def movable?
    true
  end

  def move_to phd
    self.parent = phd
    self.save
  end

  def parent_siblings
    Place.level(parent_type)
  end
end
