$(function(){
  addRecipient();
  removeRecipient();
});

function addRecipient(){
  $('#btn-add-recipient').click(function(){
    newRecipient = $('#recipient').val();
    $('#list-recipients').append("<li><span class='rounded'>"+newRecipient+"</span><input type='hidden' name='external_sms_setting[recipients][]' value='"+newRecipient+"' />"+
    " <a href='#'><span class='glyphicon glyphicon-remove-circle btn-remove-recipient' data-value='"+newRecipient+"'></span></a></li>");
  });
}

function removeRecipient(){
  $('.btn-remove-recipient').click(function(){
    console.log('removeRecipient');
    recipient = $(this).data("value");
    $("#recipient-"+recipient).remove();
  });
}
