class Date
  def dayname
     DAYNAMES[self.wday]
  end

  def abbr_dayname
    ABBR_DAYNAMES[self.wday]
  end

  def day_of_year
    p "yday #{self.yday}"
    self.yday #+ 4 #ENV['WKST'].to_i 
  end
end
