class HC < Place
  def self.model_name
    Place.model_name
  end

  def parent_type
    OD.kind
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

  def movable?
    true
  end

  def move_to od
    self.parent = od
    self.save
  end

  def parent_siblings
    Place.level(parent_type).where(ancestry: phd.id)
  end
end
