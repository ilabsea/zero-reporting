function odByPhd(phdId, success, error){
  var url = "/phds/" + phdId + "/od_list"
  $.ajax({
    method: 'GET',
    url: url,
    success: success,
    error: error
  })
}