$(function() {
  events = [
    { 'source': '.sms-reminder-toggle', 'dest': '#sms-reminder-variables' },
    { 'source': '.telegram-reminder-toggle', 'dest': '#telegram-reminder-variables' },
    { 'source': '.voice-reminder-toggle', 'dest': '#voice-reminder-variables' },
    { 'source': '.toggle', 'dest': '#toggle-div' }
  ]

  initilize();
});

function initilize() {
  $('.time-select').timepicker({ minTime: '8:00am', maxTime: '8:00pm', 'timeFormat': 'H:i' });

  // For rendering at initiated
  events.forEach(function(event) {
    toggleChildElement(event['source'], event['dest']);
  });

  initEventListenter();
}

function initEventListenter() {
  events.forEach(function(event) {
    $(document.body).delegate(event['source'], 'click', function() {
      toggleChildElement(event['source'], event['dest']);
    });
  });
}
