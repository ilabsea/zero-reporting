$(function(){
  initFilterForm();
});

function initFilterForm(){
  $(".log-kind").on("change", function() {
    location.href = location.protocol + "//" + location.host + "/logs?" + requestParams().join("&");
  });

  $(".log-type").on("change", function() {
    location.href = location.protocol + "//" + location.host + "/logs?" + requestParams().join("&");
  });
}

function requestParams() {
  var params = [];
  params.push("kind=" + $(".log-kind").val());
  if ($(".log-type").val() != null && $(".log-type").val() != "") {
    params.push("type=" + $(".log-type").val());
  }
  return params;
}
