$(function(){
  reportListInit();
  reviewWeekNumberChanged();
  subscribeHubEventHandler();
  lastDayChanged();
});

function reportListInit() {
  $('[data-toggle="tooltip"]').tooltip();
}

function lastDayChanged() {
  $(".report-last-day").on("change", function() {
    var url = location.href.replace(/(last_day=)[^\&]+/, '$1' + $(this).val());
    location.href = url
  });
}

function reviewWeekNumberChanged() {
  $('.weekly-report').on('change', function() {
    var _self = this;
    var reportId = _self.id;
    var placeId = $("#place_report_" + reportId).val();
    var weekNumber = $(_self).val();
    if(weekNumber) {
      if(placeId) {
        var url = "/weekly_place_reports?place_id=" + placeId + "&week=" + weekNumber;
        $.ajax({
          method: 'GET',
          url: url,
          success: function(response){
            if(response.length > 0) {
              var r = confirm("Week " + weekNumber + " of this place is already reviewed, are you sure you want to review as this week?");
              (r == true ? reviewedReport(reportId, weekNumber) : location.reload(true));
            } else {
              reviewedReport(reportId, weekNumber);
            }
          }
        });
      }
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
      setTimeout(function() { location.reload(); }, 3000);
    },
    error: function(response){
      setNotification('alert', response.responseText);
    }
  });
}

function reviewedReport(reportId, weekNumber) {
  var url = "/reports/" + reportId + "/update_week";
  $.ajax({
    method: 'PUT',
    url: url,
    data: {week: weekNumber},
    success: function(){
      setNotification('notice', "Report was successfully updated");
      setTimeout(function() { location.reload(); }, 3000);
    },
    error: function(){
      _self.checked = !_self.checked;
      setNotification('alert', "Failed to update report");
    }
  });
}
