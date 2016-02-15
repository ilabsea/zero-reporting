$(function(){
  handleForm();
  handlePrametersLink();
})

function handleForm(){
  $(".marked-place").on('change', function(){
    var $this = $(this)
    var $destroyable = $this.parent().find(".destroyable-alert-place")
    if($destroyable.length > 0) {
      $destroyable.get(0).checked = ! this.checked
    }
  })
}

function handlePrametersLink(){
  $('.param-link').click(function() {
    var $this = $(this);
    var $input = $('#' + $this.attr('data-selector'));
    $input.replaceSelection($this.text());
    return false;
  });
}
