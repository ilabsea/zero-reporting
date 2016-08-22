module Auditor
  class PlaceAuditor
    attr_reader :places, :setting
    
    def initialize places, setting
      @places = places
      @setting = setting
    end

    def audit; end
  end
end
