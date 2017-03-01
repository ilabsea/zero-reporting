class PHD < Place
	def self.model_name
    Place.model_name
  end

  def parent_type
    nil
  end

	def child_type
		OD.kind
	end

	def child_allowed?
		true
	end

  def movable?
    false
  end

  def move_to place
    raise "PHD can't move"
  end

  def parent_siblings
    []
  end
end
