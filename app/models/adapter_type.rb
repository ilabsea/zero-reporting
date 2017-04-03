class AdapterType
  def self.for alert, type = :sms
    "Adapter::#{type.to_s.camelize}AlertAdapter".constantize.new alert
  end
end
