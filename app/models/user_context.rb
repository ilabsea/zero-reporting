class UserContext
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def reports
  end

  def phds_list
  end

  def ods_list(place_id)
  end

  def self.for(user)
    user.admin? ? UserContexts::AdminUserContext.new(user) : UserContexts::NormalUserContext.new(user)
  end

end
