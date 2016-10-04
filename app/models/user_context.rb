class UserContext
  def self.for(user)
    user.admin? ? UserContext::AdminUser.new(user) : UserContext::NormalUser.new(user)
  end
end
