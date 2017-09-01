$(function(){
  $('#user-file-select').on('change', function(){
    uploadUserFile('/users/decode', function(data){
      buildUserList(data);
    });
  });

  $('#btn-import-user').on('click', function(){
    uploadUserFile('/users/import/', function(data){
      setNotification('notice', "Successfully imported " +  data["row_imported"] + " user(s)");
      setTimeout(
        function(){
          window.location = "/users"
        }, 3000);
    });
  });

});


function uploadUserFile(url,callback){
  var formData = new FormData();
  var files = $('#user-file-select')[0].files;
  formData.append('user', files[0], files[0].name);

  $.ajax({
      url: url,
      type: 'POST',
      data: formData,
      async: false,
      success: function (data) {
        callback(data)
      },
      error: function (error) {
        alert('An error occurred!');
      },
      cache: false,
      contentType: false,
      processData: false
  });
}

function buildUserList(users){
  $("#myTmpTree").show();
  $("#tbody").empty();
  var table = $("#errors-table")[0];
  var tbody = table.getElementsByTagName("tbody")[0]
  var errorStat = false

  $.each( users, function( key, user ) {
    var row = tbody.insertRow(tbody.rows.length);
    var cellLogin = row.insertCell(0);
    var cellFullname = row.insertCell(1);
    var cellEmail = row.insertCell(2);
    var cellPhoneNumber = row.insertCell(3);
    var cellPlace = row.insertCell(4);
    var cellError = row.insertCell(5);

    cellLogin.innerHTML = user["username"];
    cellFullname.innerHTML = user["name"];
    cellEmail.innerHTML = user["email"];
    cellPhoneNumber.innerHTML = user["phone"];
    cellPlace.innerHTML = user["location_code"];

    if(user['errors'].length > 0){
      cellError.innerHTML = generateErrorList(user['errors']);
      errorStat = true ;
    }
    else{
      cellError.innerHTML = '<span class="label label-sm label-success left" style="margin-left: 13px;">Accepted</span>'
    }
  });
}


function generateErrorList(errors){
  html = '<div class="red inline left"><ul>'
  $.each( errors, function( i, error ) {
    $.each( error, function( key, message ) {
      html = html + "<li>" + key +" "+ message[0] + "</li>";
    });

  });
  html = html + "</ul></div>"
  return html;
}
