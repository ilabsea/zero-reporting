$(function(){
  fetchOd()
})

function fetchOd() {
  $("#member_phd_id").on('change', function(){
    var $this = $(this)
    var phdId = $this.val()

    removeOptions("#member_od_id")

    if(phdId) {
      odByPhd(phdId, function(response){
        addOptions("#member_od_id", response)
      })
    }
    else {
      console.log("Failed to fetch member")
    }
  })

}

function addOptions(selector, options) {
  $select = $(selector)
  $.each(options, function(_, option){
    var $option = $("<option value='"+ option[1] +"'>" + option[0] + "</option>")
    $select.append($option)
  })
}

function removeOptions(selector) {
  $(selector + " option[value!='']").remove()
}