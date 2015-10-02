$(function(){
  handleUploadForm()
  handleConfirmImport()
})

handleUploadForm = function(){
  var form = document.getElementById('file-form');
  var fileSelect = document.getElementById('file-select');
  var uploadButton = document.getElementById('upload-button');
  form.onsubmit = function(event) {
    event.preventDefault();

    // Update button text.
    uploadButton.innerHTML = 'Uploading...';

    var files = fileSelect.files;
    var formData = new FormData();
    formData.append('place', files[0], files[0].name);
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/places/upload_location', true);
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    xhr.onload = function () {
      if (xhr.status === 200) {
        uploadButton.innerHTML = 'Upload';
        data = JSON.parse(xhr.responseText);
        tree = build_tree(data["data"]);
        html = build_root_tree(tree);
        $("#myTmpTree")[0].innerHTML = html;
        tmpNodeClick();
      }
      else {
        alert('An error occurred!');
      }
    };
    xhr.send(formData);
  }
}

build_tree = function(places){
  ul_div = ""
  if(places.length > 0){
    ul_div = ul_div + '<ul style="display: block;">';
    for(var i=0; i< places.length; i++){
      ul_div = ul_div + '<li class="tree-node-wrapper active">'
      if(places[i]["sub"]){
        ul_div = ul_div + build_arrow_tree();
        ul_div = ul_div + '<a class="tree-node " href="javascript:void(0)" data-id="' + places[i]["id"] + '">' + places[i]["name"] + " (" + places[i]["sub"].length + ')</a>'
        ul_div = ul_div + build_tree(places[i]["sub"])
      }
      else{
        ul_div = ul_div + '<a class="tree-node " href="javascript:void(0)" data-id="' + places[i]["id"] + '">' + places[i]["name"] + '(0)</a>'
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
            '<span class="tree-icon-closed">' +
              '<i class="glyphicon glyphicon-triangle-right"></i>' +
            '</span>' +
            '<span class="tree-icon-opened">' +
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

      tmpNodeClick();
    }
    else {
      alert('An error occurred!');
    }
  };
  xhr.send(formData);
}


