module Contexts
  class UserContext
    attr_reader :user

    def initialize(user_model)
      @user_model = user_model
    end

    def reports
      @user_model.reports
    end

    def phds_list
      @user_model.phds_list
    end

    def ods_list(place_id)
      @user_model.ods_list(place_id)
    end

    def self.for(user)
      user_model = user.admin? ? Users::AdminUser.new(user) : Users::NormalUser.new(user)
      Contexts::UserContext.new(user_model)
    end
  end
end
