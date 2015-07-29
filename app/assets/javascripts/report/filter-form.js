$(function(){
  initFilterForm()
  updateReportStatus()
})


function updateReportStatus() {
  $('.report-status').on('change', function(){
    var _self = this
    var report_id = _self.value
    var url = "/reports/" + report_id + "/toggle_status"
    $.ajax({
      method: 'PUT',
      url: url,
      success: function(){
        setNotification('notice', "Status updated")
      },
      error: function(){
        _self.checked = !_self.checked
        setNotification('alert', "Failed to update")
      }
    })
  })
}

function initFilterForm(){
  $("#phd").on('change', function(){
    var $this = $(this)
    var phdId = $this.val()
    var $od    = $("#od")

    $od.find("option[value!='']").remove()

    $.ajax({
      url: '/places/ods_list',
      data: { phd_id: phdId },
      success: function(reponse){
        $.each(reponse, function(i){
          var name = reponse[i][0]
          var value = reponse[i][1]
          option = $("<option>")
          option.text(name)
          option.attr("value", value)
          $od.append(option)
        })
      }
    })
  })
}
