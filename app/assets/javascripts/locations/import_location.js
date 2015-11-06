handleUploadForm = function(){
  var form = document.getElementById('file-form');
  var fileSelect = document.getElementById('file-select');
  var uploadButton = document.getElementById('upload-button');

  // Update button text.

  var files = fileSelect.files;
  var formData = new FormData();
  formData.append('place', files[0], files[0].name);
  var xhr = new XMLHttpRequest();
  xhr.open('POST', '/places/upload_location', true);
  xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
  xhr.onload = function () {
    if (xhr.status === 200) {
      data = JSON.parse(xhr.responseText);
      if(data["error"]){
        html = build_error(data["error"])
        $("#myTmpTree")[0].innerHTML = html;
      }
      else{
        tree = build_tree(data["data"]);
        html = build_root_tree(tree);
        $("#myTmpTree")[0].innerHTML = html;
        tmpNodeClick();
      }
      if(data["error"])
        $("#btn-import").hide();
      else
        $("#btn-import").show();
    }
    else {
      alert('An error occurred!');
    }
  };
  xhr.send(formData);
  return false;
}

build_error = function(errors){
  var html = '<br /><br /><div class="well">';
  html =  html + '<h4 class="red smaller strong">Errors found</h4>';
  html =  html + errors;
  html =  html + '</div>';
  return html;
}

build_tree = function(places){
  ul_div = ""
  if(places.length > 0){
    ul_div = ul_div + '<ul style="display: block;">';
    for(var i=0; i< places.length; i++){
      ul_div = ul_div + '<li class="tree-node-wrapper active">'
      if(places[i]["sub"]){
        ul_div = ul_div + build_arrow_tree();
        ul_div = ul_div + '<a class="tree-node " href="javascript:void(0)" data-id="' + places[i]["id"] + '">' + places[i]["level"] + " - " + places[i]["name"] + " (" + places[i]["id"] + ')</a>'
        ul_div = ul_div + build_tree(places[i]["sub"])
      }
      else{
        ul_div = ul_div + '<a class="tree-node " href="javascript:void(0)" data-id="' + places[i]["id"] + '">' + places[i]["level"] + " - " + places[i]["name"] + ' (' + places[i]["id"] + ')</a>'
      }
      ul_div = ul_div + "</li>"
    }
    ul_div = ul_div + "</ul>";
  }
  return ul_div
}

build_root_tree = function(html){
  ul_div = '<ul id="myTree" data-toggle="nav-tree">';
  ul_div = ul_div + '<li id="tree-root" class="tree-node-wrapper active">';
  ul_div = ul_div + html;
  ul_div = ul_div + '</li>';
  ul_div = ul_div + '</ul>';
  return ul_div;
}

build_arrow_tree = function(){
  return '<span class="opener closed">' + 
            '<span class="tree-icon-opened">' +
              '<i class="glyphicon glyphicon-triangle-right"></i>' +
            '</span>' +
            '<span class="tree-icon-close">' +
              '<i class="glyphicon glyphicon-triangle-bottom"></i>' +
            '</span>' +
          '</span>';
}

tmpNodeClick = function(){
  $(".tree-node").on('click', function(){
    var $this = $(this)
    $("ul[data-toggle=nav-tree] a").removeClass("selected")
    $this.addClass("selected")

    updateSelected($this)
    var placeId = $this.data().id
    return false
  })
}

handleConfirmImport = function(){
  var form = document.getElementById('file-form');
  var fileSelect = document.getElementById('file-select');
  var uploadButton = document.getElementById('upload-button');
  var files = fileSelect.files;
  var formData = new FormData();
  formData.append('place', files[0], files[0].name);
  var xhr = new XMLHttpRequest();
  xhr.open('POST', '/places/confirm_upload_location', true);
  xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
  xhr.onload = function () {
    if (xhr.status === 200) {
      data = JSON.parse(xhr.responseText);
      setNotification('notice', "Successfully imported " +  data["row_imported"] + " location(s)"); 
      setTimeout(
        function(){ 
          window.location = "/users/import"
        }, 3000);
    }
    else {
      alert('An error occurred!');
    }
  };
  xhr.send(formData);
}

handleUploadUserForm = function(){
  var form = document.getElementById('file-form');
  var fileSelect = document.getElementById('file-select');
  var uploadButton = document.getElementById('upload-button');

  // Update button text.

  var files = fileSelect.files;
  var formData = new FormData();
  formData.append('users', files[0], files[0].name);
  var xhr = new XMLHttpRequest();
  xhr.open('POST', '/users/upload_users', true);
  xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
  xhr.onload = function () {
    if (xhr.status === 200) {
      users = JSON.parse(xhr.responseText)["data"];
      
      $("#myTmpTree").show();
      $("#tbody").empty();
      var table = $("#errors-table")[0];
      var tbody = table.getElementsByTagName("tbody")[0]
      var errorStat = false
      for(var i=0; i< users.length; i++){
        var row = tbody.insertRow(tbody.rows.length);
        var cellLogin = row.insertCell(0);
        var cellFullname = row.insertCell(1);
        var cellEmail = row.insertCell(2);
        var cellPhoneNumber = row.insertCell(3);
        var cellPlace = row.insertCell(4);
        var cellError = row.insertCell(5);

        cellLogin.innerHTML = users[i][0];
        cellFullname.innerHTML = users[i][1];
        cellEmail.innerHTML = users[i][2];
        cellPhoneNumber.innerHTML = users[i][3];
        cellPlace.innerHTML = users[i][6];
        if(users[i][7]){
          cellError.innerHTML = generateErrorList(users[i][7]);
          errorStat = true ;
        }
        else{
          cellError.innerHTML = '<span class="label label-sm label-success left" style="margin-left: 13px;">Accepted</span>'
        }
        if(errorStat)
          $("#btn-import").hide();
        else
          $("#btn-import").show();
      } 
    }
    else {
      alert('An error occurred!');
    }
  };
  xhr.send(formData);
  return false;
}

handleConfirmImportUser = function(){
  var form = document.getElementById('file-form');
  var fileSelect = document.getElementById('file-select');
  var uploadButton = document.getElementById('upload-button');

  // Update button text.

  var files = fileSelect.files;
  var formData = new FormData();
  formData.append('users', files[0], files[0].name);
  var xhr = new XMLHttpRequest();
  xhr.open('POST', '/users/confirmed_upload_users', true);
  xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
  xhr.onload = function () {
    if (xhr.status === 200) {
      users = JSON.parse(xhr.responseText)["data"];
      setNotification('notice', "Successfully imported users"); 
      setTimeout(
        function(){ 
          window.location = "/users"
        }, 3000);
    }
    else {
      alert('An error occurred!');
    }
  };
  xhr.send(formData);
  return false;
}

generateErrorList = function(errors){
  html = '<div class="red inline left"><ul>'
  for(var i=0; i< errors.length; i++){
    html = html + "<li>" + errors[i] + "</li>";
  }
  html = html + "</ul></div>"
  return html;
}


