$(function(){
  initFilterForm()
})


function initFilterForm(){
  $("#phd").on('change', function(){
    var $this = $(this)
    var phdId = $this.val()
    var $od    = $("#od")

    $od.find("option[value!='']").remove()

    $.ajax({
      url: '/places/ods_list',
      data: { phd_id: phdId },
      success: function(reponse){
        $.each(reponse, function(i){
          var name = reponse[i][0]
          var value = reponse[i][1]
          option = $("<option>")
          option.text(name)
          option.attr("value", value)
          $od.append(option)
        })
      }
    })
  })
}
