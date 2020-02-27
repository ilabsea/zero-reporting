class Blacklist
  def self.exist?(tel = nil)
    return false if tel.nil?

    Setting.blacklist_numbers.each do |blacklist_number|
      blacklist_tel = Tel.new blacklist_number
      return true if blacklist_tel.equal?(tel)
    end

    return false
  end
end
