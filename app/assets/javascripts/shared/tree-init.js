$(function(){
  //initTree()
  nodeClick()
})

function initTree(){
  $('.easy-tree').easytree({
    // selectable: true,
    // deletable: false,
    // editable: false,
    // addable: false,
    allowActivate: false
  });
}

function nodeClick(){
  $(".tree-node").on('click', function(){
    var $this = $(this)
    console.log($this.data())
    return false
  })
}