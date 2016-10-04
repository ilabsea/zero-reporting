$(function() {
  initilize();
});

function initilize() {
  $('.time-select').timepicker({ minTime: '8:00am', maxTime: '8:00pm', 'timeFormat': 'H:i' });

  // For rendering at initiated
  toggleChildElement('.sms-reminder-toggle', '#sms-reminder-variables');
  toggleChildElement('.voice-reminder-toggle', '#voice-reminder-variables');

  initEventListenter();
}

function initEventListenter() {
  $(document.body).delegate('.sms-reminder-toggle', 'click', function() {
    toggleChildElement('.sms-reminder-toggle', '#sms-reminder-variables');
  });

  $(document.body).delegate('.voice-reminder-toggle', 'click', function() {
    toggleChildElement('.voice-reminder-toggle', '#voice-reminder-variables');
  });
}
