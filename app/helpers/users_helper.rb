module UsersHelper
  def reportable_state_for(userType)
    if( userType == 'HC' )
      return '<input type="checkbox" checked class="form-control ace ace-switch ace-switch-4 btn-empty"  disabled>'
    else
      return '<input type="checkbox" class="form-control ace ace-switch ace-switch-4 btn-empty" disabled>'
    end
  end
end
