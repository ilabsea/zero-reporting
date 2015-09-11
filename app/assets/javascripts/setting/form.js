$(function() {
  allowKeyInput($(".numeric"), /[0-9]/);
  allowKeyInput($(".time"), /[0-9:]/);
  connectToVerboice();
  handleProjectChange()
  handleProjectVariableChange()


  variableCollapsable()
});

function variableCollapsable(){
  $(".variable-collapsable").on('click', function(){
    var $this = $(this)
    $this.parent().parent().find(".panel-body").toggle()
    return false
  })
}



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

function handleProjectVariableChange(){
  $(document.body).delegate('.project_variable', 'change', function(){
    var $this = $(this)
    var variable_name = this.options[this.selectedIndex].text
    var $project_variable_name = $this.parent().find(".project_variable_name")
    $project_variable_name.val(variable_name)
  })
}

function handleProjectChange(){
  $("#project").on('change', function(){
    $this = $(this);
    var project_id = $this.val()
    setNotification("Info", "Connecting to server")

    $.ajax({
      method: 'GET',
      url: '/project_variables',
      data: {project: project_id},
      success: function(response){
        console.log(response)
        $('#setting-variables').html(response)
        setNotification("notice", "Retrieved project variable successfully")
      },
      error: function(){
        update_select('#project_variable', [])
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