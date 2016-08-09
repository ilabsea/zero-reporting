module Adapter
	class UserContextAdapter
		def initialize user_context
			@user_context = user_context
		end

		def reports
			@user_context.reports
	  end

	  def phds_list
	  	@user_context.phds_list
	  end

	  def ods_list(place_id)
	  	@user_context.ods_list(place_id)
	  end 
	end
end
