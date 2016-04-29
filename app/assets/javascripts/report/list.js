$(function(){
  reviewWeekNumberChanged();
  subscribeHubEventHandler();
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
          location.reload();
        },
        error: function(){
          _self.checked = !_self.checked;
          setNotification('alert', "Failed to update report");
        }
      });
    }
  });
}

function subscribeHubEventHandler() {
  $('.hub').on('click', function() {
    $("#hubOK").attr('data-id', $(this).attr('data-id'));
    $("#hubModal").modal('show');
  });

  $("#hubCancel").on('click', function() {
    $("#hubModal").modal('hide');
  });

  $("#hubOK").on('click', function(event) {
    notifyHub($(this).attr('data-id'));
    $("#hubModal").modal('hide');
  });
}

function notifyHub(reportId) {
  var url = "/hub_push_notifications"
  $.ajax({
    method: "POST",
    data: {"report_id": reportId},
    url: url,
    success: function(){
      setNotification('notice', "Report was successfully submitted to CamEwarn");
    },
    error: function(response){
      setNotification('alert', response.responseText);
    }
  });
}
