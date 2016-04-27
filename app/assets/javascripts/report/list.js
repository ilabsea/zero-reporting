$(function(){
  reviewWeekNumberChanged();
  notifyHub();
});

function reviewWeekNumberChanged() {
  $('.weekly-report').on('change', function() {
    var _self = this;
    var reportId = _self.id;
    var weekNumber = $(_self).val();
    if(weekNumber) {
      var url = "/reports/" + reportId + "/update_week";
      $.ajax({
        method: 'PUT',
        url: url,
        data: {week: weekNumber},
        success: function(){
          setNotification('notice', "Report was successfully updated");
        },
        error: function(){
          _self.checked = !_self.checked;
          setNotification('alert', "Failed to update report");
        }
      });
    }
  });
}

function notifyHub() {
  $('.hub').on('click', function() {
    var reportId = $(this).attr('data-id');
    alert(reportId)
    var url = "/hub_notifications"
    $.ajax({
      method: "POST",
      data: {"report_id": reportId},
      url: url,
      success: function(){
        setNotification('notice', "Report was successfully submitted to CamEwarn");
      },
      error: function(){
        setNotification('alert', "Failed to submit to CamEwarn");
      }
    });
  });
}
