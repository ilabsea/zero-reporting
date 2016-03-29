$(function(){
  addRecipient();
  removeRecipient();
});

function addRecipient(){
  $('#btn-add-recipient').click(function(){
    recipient = $('#recipient');
    newRecipient = recipient.val().trim();
    if(newRecipient != ""){
      $('#list-recipients').append("<li id='recipient-"+newRecipient+"'><span class='rounded'>"+newRecipient+"</span><input type='hidden' name='external_sms_setting[recipients][]' value='"+newRecipient+"' />"+
      " <a href='#' onclick='removeRecipient("+newRecipient+")' class='btn-remove-recipient'><span class='glyphicon glyphicon-remove-circle' data-value='"+newRecipient+"'></span></a></li>");
      recipient.val('');
    }
  });
}

function removeRecipient(recipient){
  $("#recipient-"+recipient).remove();
}
