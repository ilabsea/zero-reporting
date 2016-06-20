$(function(){
  locationOptionChanged();
  $(".js-example-basic-multiple").select2({
    ajax: {
      url: rootUrl + "api/places",
      dataType: 'json',
      delay: 250,
      data: function (params) {
        return {
          q: params.term, // search term
          level: $(".select.optional.location-level").val(),
          page: params.page
        };
      },
      processResults: function (data, params) {
        params.page = params.page || 1;

        return {
          results: displayFormat(data),
          pagination: {
            more: (params.page * 30) < data.total_count
          }
        };
      },
      cache: true
    },
    placeholder: "Location name",
    allowClear: true,
    minimumInputLength: 1
  });

});

function displayFormat(items) {
  var formatItems = [];
  for(var i = 0; i < items.length; i++) {
    var item = items[i];
    formatItems.push({
      id: item.id,
      text: item.name + " - " + item.kind_of
    });
  }
  return formatItems;
}

function locationOptionChanged() {
  $(".location-level").on('change', function() {
    if($(this).val() == '') {
      $(".locations").addClass('hidden');
    } else {
      $(".locations").removeClass('hidden');
    }
  });
}
