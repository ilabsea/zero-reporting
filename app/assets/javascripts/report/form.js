$(function(){
  REVIEWED = 1;

  reviewedChanged();

  initFilterForm();
  updateWeekNumberReport();
});

function updateWeekNumberReport() {
  $('.weekly-report').on('change', function() {
    var _self = this;
    var report_id = _self.id;
    var week_number = $(_self).val();
    if(week_number) {
      var url = "/reports/" + report_id + "/update_week?week=" + week_number;
      $.ajax({
        method: 'PUT',
        url: url,
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

function initFilterForm(){
  var _self = this;

  var $reviewed = $("#reviewed");
  $reviewed.on('change', function() {
    reviewedChanged();
  });

  $("#phd").on('change', function() {
    var $this = $(this)
    var phdId = $this.val()
    var $od    = $("#od")

    $od.find("option[value!='']").remove()

    $.ajax({
      url: '/places/ods_list',
      data: { phd_id: phdId },
      success: function(response){
        $.each(response, function(i){
          addItemToCombo(response[i][0], response[i][1], $od);
        });
      }
    })
  });
}

function addItemToCombo(text, value, combo, valueSelected) {
  var element = $("<option>");
  element.text(text);
  element.attr("value", value);
  if(value == valueSelected) {
    element.attr("selected", "selected");
  }
  combo.append(element);
}

function reviewedChanged() {
  var $divFromWeek = $(".from-week-group");
  var $divToWeek = $(".to-week-group");
  var $fromWeekSelect = $("#from_week");
  var $toWeekSelect = $("#to_week");

  $fromWeekSelect.find("option[value!='']").remove();
  $toWeekSelect.find("option[value!='']").remove();

  var $reviewed = $("#reviewed");
  if($reviewed.val() == REVIEWED) {
    var $year = $("#year");

    $divFromWeek.show();
    $divToWeek.show();

    $.ajax({
      url: '/weeks',
      data: { year: $year.val() },
      success: function(response){
        $.each(response, function(i){
          addItemToCombo(response[i]['display'], response[i]['id'], $fromWeekSelect, fromWeek);
          addItemToCombo(response[i]['display'], response[i]['id'], $toWeekSelect, toWeek);
        });
      }
    });
  } else {
    $divFromWeek.hide();
    $divToWeek.hide();
  }
}
