$(function(){
  $('#user_sms_alertable').change(function() {
    var val = $('#user_sms_alertable:checked').val()
    if(val === '1'){
      $('#disable_alert_reason').addClass('display-none');
    }else{
      $('#disable_alert_reason').removeClass('display-none');
      $('#user_disable_alert_reason').val('');
    }
  });
});
