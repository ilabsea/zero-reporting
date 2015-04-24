$(function(){
  animateAlert();
})

function animateAlert(){
  $alert = $(".alert-animate")
  
  var appearTime    = 2 * 1000
  var disappearTime = 1.5 * 1000

  $alert.animate({ opacity: 1 }, appearTime, function() {
    $alert.animate({opacity: 0 }, disappearTime, function() {
      $alert.remove()
    })
  })
}