$(function(){
  addRecipient();
  removeRecipient();
});

function addRecipient(){
  $('#btn-add-recipient').click(function(){
    var recipient = $('#recipient');
    var newRecipient = recipient.val();
    if(newRecipient != ""){
      $('#list-recipients').append("<li id='recipient-"+newRecipient+"'><span class='rounded'>"+newRecipient+"</span><input type='hidden' name='external_sms_setting[recipients][]' value='"+newRecipient+"' />"+
      " <a href='#' class='btn-remove-recipient'><span class='glyphicon glyphicon-remove-circle' data-value='"+newRecipient+"'></span></a></li>");
      recipient.val('');
    }
  });
}

function removeRecipient(recipient){
  $(document.body).on('click', ".btn-remove-recipient", function() {
    $(this).parent().remove()
  });
}
