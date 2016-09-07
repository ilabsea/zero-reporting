class UserContext::NormalUser
  def initialize user
    @user = user
  end

  def reports
    if @user.place.phd?
      reprots_per_place.where(["reports.phd_id = ?", @user.place_id ])
    elsif @user.place.od?
      reprots_per_place.where(["reports.od_id = ?", @user.place_id ])
    else
      Report.none
    end
  end

  def phds_list
    [[@user.phd.name, @user.phd.id]]
  end

  def ods_list(place_id)
    return [[@user.od.name, @user.od.id]] if @user.od

    place_id.present? ? Place.find(place_id).children.pluck(:name, :id) : []
  end

  private
  
  def reprots_per_place
    Report.joins("INNER JOIN users ON reports.phone_without_prefix = users.phone_without_prefix")
  end
end
