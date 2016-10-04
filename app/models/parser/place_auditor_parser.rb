module Parser
  class PlaceAuditorParser
    def self.parse place_type, places, setting
      if place_type.downcase === HC.kind.downcase
        auditor = Auditor::Places::ReporterAuditor.new(places, setting)
      else
        auditor = Auditor::Places::SupervisorAuditor.new(places, setting)
      end
      
      auditor
    end
  end
end
