class UserContext
  def initialize(user)
    @user = user
  end

  def reports
    if @user.is_admin?
      Report.all
    elsif @user.place.is_kind_of_phd?
      reprots_per_place.where(["reports.phd_id = ?", @user.place_id ])
    elsif @user.place.is_kind_of_od?
      reprots_per_place.where(["reports.od_id = ?", @user.place_id ])
    else
      Report.none
    end
  end

  def phds_list
    return Place.phds_list if @user.is_admin?
    return [[@user.phd.name, @user.phd.id]]
  end

  def ods_list(phd_id)
    return Place.ods_list(phd_id) if @user.is_admin?
    return [[@user.od.name, @user.od.id]] if @user.od
    Place.ods_list(phd_id) #phd user
  end

  def reprots_per_place
    Report.joins("INNER JOIN users ON reports.phone_without_prefix = users.phone_without_prefix")
  end

end