$(function(){
  REVIEWED = 1;

  reviewedChanged();
  initReportFilterForm();
});

function initReportFilterForm() {
  $("#reviewed").on('change', function() {
    reviewedChanged();
  });

  $("#year").on('change', function() {
    yearChanged(true);
  });

  $("#phd").on('change', function() {
    var $this = $(this)
    var phdId = $this.val()
    var $od    = $("#od")

    $od.find("option[value!='']").remove()

    $.ajax({
      url: '/places/ods_list',
      data: { phd_id: phdId },
      success: function(response){
        $.each(response, function(i){
          addItemToCombo(response[i][0], response[i][1], $od);
        });
      }
    })
  });
}

function addItemToCombo(text, value, combo, valueSelected) {
  var element = $("<option>");
  element.text(text);
  element.attr("value", value);
  if(value == valueSelected) {
    element.attr("selected", "selected");
  }
  combo.append(element);
}

function reviewedChanged() {
  var $divYear = $(".year");
  var $divFromWeek = $(".from-week-group");
  var $divToWeek = $(".to-week-group");
  var $year = $("#year");

  $year.find("option[value!='']").remove();

  var $reviewed = $("#reviewed");
  if($reviewed.val() == REVIEWED) {
    var years = yearNearBy(2);
    $.each(years, function(i){
      addItemToCombo(years[i], years[i], $year, currentYear);
    });

    yearChanged();

    $divYear.show();
    $divFromWeek.show();
    $divToWeek.show();

  } else {
    $divYear.hide();
    $divFromWeek.hide();
    $divToWeek.hide();
  }
}

function yearChanged(isWeekReset) {
  var $year = $("#year");
  var $fromWeekSelect = $("#from_week");
  var $toWeekSelect = $("#to_week");

  $fromWeekSelect.find("option[value!='']").remove();
  $toWeekSelect.find("option[value!='']").remove();

  $.ajax({
    url: '/weeks',
    data: { year: $year.val() },
    success: function(response){
      $.each(response, function(i){
        if(isWeekReset) {
          addItemToCombo(response[i]['display'], response[i]['id'], $fromWeekSelect);
          addItemToCombo(response[i]['display'], response[i]['id'], $toWeekSelect);
        } else {
          addItemToCombo(response[i]['display'], response[i]['id'], $fromWeekSelect, fromWeek); // fromWeek is global variable
          addItemToCombo(response[i]['display'], response[i]['id'], $toWeekSelect, toWeek); // toWeek is global variable
        }
      });
    }
  });
}

function yearNearBy(number) {
  var currentYear = new Date().getFullYear();
  var years = [];
  for(var i = 0 - number; i <= number; i++) {
    years.push(currentYear + i)
  }
  return years;
}
