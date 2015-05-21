$(function() {
  allowKeyInput($(".numeric"), /[0-9]/);
  allowKeyInput($(".time"), /[0-9:]/);
  connectToVerboice();
  handleProjectChange()
});

function connectToVerboice() {
  $("#btn-verboice-connect").on('click', function(){
    $this = $(this)
    var url = $this.attr("href")
    var email = $("#email").val()
    var password = $("#password").val()

    var data = { email: email, password: password}
    setNotification("info", "Connecting to Verboice server")
    $.ajax({
      method: 'PUT',
      url: url,
      data: data,
      dataType: 'json',
      success: function(response){
        setNotification("notice", "Successfully Connected to verboice")
        window.location.reload()
      },
      error: function(response){
        setNotification('alert', "Failed to connect to verboice")
      }
    })
    return false
  })
}

function handleProjectChange(){
  $("#project").on('change', function(){
    $this = $(this);
    var project_id = $this.val()

    var project_call_flows = $.grep(call_flows, function(call_flow, index){
        if( call_flow.project_id == project_id)
          return call_flow
    })

    update_select('#call_flow', project_call_flows)
    setNotification("Info", "Connecting to server")

    $.ajax({
      method: 'GET',
      dataType: 'json',
      url: '/schedules',
      data: {project: project_id},
      success: function(response){
        window.schedules = response
        update_select('#schedule', schedules)
        setNotification("notice", "Retrieved schedule successfully")
      },
      error: function(){
        window.schedules = []
        update_select('#schedule', schedules)
        setNotification("alert", "Failed to retrieved schedules, make sure you are able to connect to Verboice")
      }
    })
  })
}

function update_select(selector, resultSets) {
  var $select = $(selector)
  $select.find("option[value!='']").remove()

  $.each(resultSets, function(index, item){
    var $option = $("<option>" + item.name + "</option>").attr('value', item.id)
    $select.append($option)
  })
}