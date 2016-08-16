module Contexts
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
      user.admin? ? Contexts::User::AdminUserContext.new(user) : Contexts::User::NormalUserContext.new(user)
    end
  end
end
