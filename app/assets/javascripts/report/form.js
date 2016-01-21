$(function(){
  initFilterForm()
  updateWeekNumberReport()
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
  $("#year").on('change', function() {
    var $this = $(this);
    var year = $this.val();
    var $week = $("#week");

    $week.find("option[value!='']").remove();

    $.ajax({
      url: '/weeks',
      data: { year: year },
      success: function(response){
        $.each(response, function(i){
          addItemToCombo(response[i]['display'], response[i]['id'], $week);
        });
      }
    });
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

  function addItemToCombo(text, value, combo) {
    var element = $("<option>");
    element.text(text);
    element.attr("value", value);
    combo.append(element);
  }
}
