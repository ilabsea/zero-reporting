$(function(){
  nodeClick()
  loadSelected()
  editTree()
  destroyTree()
  newTree()

  newUser()
})

function newUser(){
  $(".new-user").on('click', function(){
    var placeId = selectedNode().data().id
    if(!placeId) {
      setNotification("alert", "Please select place to for this user");
      return false
    }
    var url = "users/new?place_id=" + placeId
    window.location.href = url
    return false
  })
}


function nodeClick(){
  $(".tree-node").on('click', function(){
    var $this = $(this)
    $("ul[data-toggle=nav-tree] a").removeClass("selected")
    $this.addClass("selected")

    updateSelected($this)
    console.log($this.data())
    return false
  })
}

function loadSelected(){
  $selector = selectedNode()
  updateSelected($selector)
}

function updateSelected($selector){
  $("#selected-tree").html($selector.text())
}

function selectedNode(){
  return $("ul[data-toggle=nav-tree] a[class*=selected]")
}

function editTree() {
  $(".edit-tree").on('click', function(){
    var placeId = selectedNode().data().id
    if(!placeId){
      setNotification("alert", "Please select place to edit");
      return false
    }
    var url = "places/" + placeId + "/edit"
    window.location.href = url
  })
}

function destroyTree(){
  $(".destroy-tree").on('click', function(){
    var placeId = selectedNode().data().id
    if(!placeId){
      setNotification("alert", "Please select place to delete");
      return false
    }

    if(!confirm("Are you sure to delete this place")) {
      return false;
    }

    var url = "places/" + placeId
    $this = $(this)
    $this.attr("href", url)
  })
}

function newTree(){
  $(".new-tree").on('click', function(){
    var placeId = selectedNode().data().id
    var url = "places/new?parent_id=" + placeId
    window.location.href = url
  })
}











