$(function(){
  $('#place-file-select').on('change', function(){
    uploadPlaceFile('/places/decode', function(data){
      buildHierarchyPlaceView(data);
    });
  });

  $('#btn-import-place').on('click', function(){
    uploadPlaceFile('/places/import/', function(data){
      setNotification('notice', "Successfully imported " +  data["row_imported"] + " location(s)");
      setTimeout(
        function(){
          window.location = "/users/import"
        }, 3000);
    });
  });

});

function uploadPlaceFile(url,callback){
  var formData = new FormData();
  var files = $('#place-file-select')[0].files;
  formData.append('place', files[0], files[0].name);

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


function buildHierarchyPlaceView(data){
  if(data["error"]){
    html = buildError(data["error"])
    $("#hierarchy-place")[0].innerHTML = html;
    $("#btn-import-place").hide();
  }else{
    tree = buildTree(data["data"]);
    html = buildRootTree(tree);
    $("#hierarchy-place")[0].innerHTML = html;
    tmpNodeClick();
    $("#btn-import-place").show();
  }
}


function buildError(errors){
  var html = '<br /><br /><div class="well">';
  html =  html + '<h4 class="red smaller strong">Errors found</h4>';
  html =  html + errors;
  html =  html + '</div>';
  return html;
}

function generateErrorList(errors){
  html = '<div class="red inline left"><ul>'
  for(var i=0; i< errors.length; i++){
    html = html + "<li>" + errors[i] + "</li>";
  }
  html = html + "</ul></div>"
  return html;
}

function buildTree(places){
  ul_div = ""
  if(places.length > 0){
    ul_div = ul_div + '<ul style="display: block;">';
    for(var i=0; i< places.length; i++){
      ul_div = ul_div + '<li class="tree-node-wrapper active">';
      error_div = '';
      if(places[i]['errors'].length > 0){
        error_div = '<span class="label label-sm label-danger" style="margin-left: 13px;">Ignored</span>';
        $.each( places[i]['errors'], function( j, error ) {
          $.each( error, function( key, message ) {
            error_div = error_div + "<span class='red'> "+ key +' '+ message[0] + ",</span> ";
          });

        });

      }else {
        error_div = '<span class="label label-sm label-primary" style="margin-left: 13px;">Accepted</span>'
      }

      if(places[i]["sub"]){
        ul_div = ul_div + buildArrowTree();
        ul_div = ul_div + '<a class="tree-node " href="javascript:void(0)" data-id="' +
                  places[i]["id"] + '">' + places[i]["level"] + " - " + places[i]["name"] +
                  " (" + places[i]["id"] + ')</a>' + error_div
        ul_div = ul_div +  buildTree(places[i]["sub"])
      }
      else{
        ul_div = ul_div + '<a class="tree-node " href="javascript:void(0)" data-id="' +
                places[i]["id"] + '">' + places[i]["level"] + " - " + places[i]["name"] +
                ' (' + places[i]["id"] + ')</a>' + error_div
      }
      ul_div = ul_div + "</li>"
    }
    ul_div = ul_div + "</ul>";
  }
  return ul_div
}

function buildRootTree(html){
  ul_div = '<ul id="myTree" data-toggle="nav-tree">';
  ul_div = ul_div + '<li id="tree-root" class="tree-node-wrapper active">';
  ul_div = ul_div + html;
  ul_div = ul_div + '</li>';
  ul_div = ul_div + '</ul>';
  return ul_div;
}

function buildArrowTree(){
  return '<span class="opener closed">' +
            '<span class="tree-icon-opened">' +
              '<i class="glyphicon glyphicon-triangle-right"></i>' +
            '</span>' +
            '<span class="tree-icon-close">' +
              '<i class="glyphicon glyphicon-triangle-bottom"></i>' +
            '</span>' +
          '</span>';
}

function tmpNodeClick(){
  $(".tree-node").on('click', function(){
    var $this = $(this)
    $("ul[data-toggle=nav-tree] a").removeClass("selected")
    $this.addClass("selected")

    updateSelected($this)
    var placeId = $this.data().id
    return false
  })
}
