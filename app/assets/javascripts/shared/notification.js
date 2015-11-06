$(function(){
  flashNotification();
})

function flashNotification(){
  setNotification(Config.Flash.key, Config.Flash.value)
}

function setNotification(key, value) {
  // $notification = $("#notification")

  if(key && value){
    // var templateData = {body: value}

    if(key == 'notice'){
      showNotice(value, 1000);
      // templateData.title = "Success"
      // templateData.type = 'info'
      // templateData.icon = 'ok'
    }
    else{
      showError(value, 1000);
      // templateData.title = "Failure"
      // templateData.type = 'danger'
      // templateData.icon = 'remove'
    }
    // $notification.show()
    // var notificationHtml = tmpl('tmpl-notification', templateData)
    // $notification.html(notificationHtml)
    // $notification.fadeOut(4000)
  }
  else{
    // $notification.hide();
  }
}