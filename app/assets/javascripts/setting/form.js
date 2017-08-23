$(function() {
  connectToVerboice();
  handleProjectChange()
  handleVerboiceVariableChange()
  handleSaveVariable()

  variableCollapsable()
  cancelVariableForm()
});

function handleSaveVariable() {
  $(".save-varialble").on('click', function(){
    var $this = $(this);
    var $form = $(this.form);

    var $errorContainer = $form.find(".error-message");
    $errorContainer.hide();

    var name = $form.find("#variable_name").val();
    var verboice_id   = $form.find("#variable_verboice_id").val();
    if(name == "" || verboice_id == "") {
      setNotification("alert", "Please enter variable name and verboice variable")
      return
    }

    var threshold_value = $form.find("#variable_threshold_value").val()
    if(threshold_value.length == 0){
      threshold_value = 0
    }

    var url = $form.attr('action');

    var data = {
      name: name,
      verboice_id: verboice_id,
      verboice_name: $form.find("#variable_verboice_name").val(),
      background_color: $form.find("#variable_background_color").val(),
      text_color: $form.find("#variable_text_color").val(),
      alert_method: $form.find('input[class=alert_method]:checked').val(),
      dhis2_data_element_uuid: $form.find("#variable_dhis2_data_element_uuid").val(),
      disabled: $form.find("#variable_disabled").is(':checked'),
      threshold_value: threshold_value,
      _method: $form.find("input[name=_method]").val()
    }

    $.ajax({
      method: 'POST',
      data: data,
      url: url,
      success: function(response){
        redirectTo("/settings")
      },
      error: function(response){
        $errorContainer.html(response.responseJSON[0])
        $errorContainer.fadeIn(1500)
        setNotification("alert", "Failed to save variable")
      }
    })
  })
}

function cancelVariableForm(){
  $(document.body).delegate(".hide-variable-form", 'click', function(){
    var $this = $(this)
    $this.parent().parent().parent().parent().find('.panel-body').hide()
  })
}

function variableCollapsable(){
  $(document.body).delegate(".variable-collapsable", 'click', function(){
    $(".panel-variable > .panel-body").hide()
    var $this = $(this)
    $this.parent().parent().parent().find('.panel-body').show()
    return false
  })
}

function connectToVerboice() {
  $(document.body).delegate("#btn-verboice-connect", 'click', function(){
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

function handleVerboiceVariableChange(){
  $(document.body).delegate('.verboice-variable-id', 'change', function(){
    var $this = $(this)
    var variable_name = this.options[this.selectedIndex].text
    var $project_variable_name = $this.parent().find(".verboice-variable-name")
    $project_variable_name.val(variable_name)
  })
}

function handleProjectChange(){
  $(document.body).delegate("#project", 'change', function(){
    $this = $(this);
    var project_id = $this.val()
    if(project_id) {
      window.location.href = '/settings?project=' + project_id
      return false;
    }
    else {
      setNotification("Info", "Please select a project")
      return false;
    }
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
