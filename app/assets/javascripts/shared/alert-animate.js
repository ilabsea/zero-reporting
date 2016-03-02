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

function showError(l, g) {
  this.show(l, "flash_error", g)
}

function showNotice(l, g) {
  this.show(l, "flash_notice", g)
}

function show(l, g, e) {
  $(".flash").remove();
  l = $("<div>").addClass("flash").addClass(g).append($("<div>").html(l));
  $("body").prepend(l);
  this.display_flash(true, e);
}

function display_flash(l, g) {
    var e = $(".flash"), a = e.children("div");
    if (e.length != 0) {
        this.set_position(e);
        if (l) {
            a.css("top", -e.outerHeight() + "px");
            g || (g = e.attr("data-hide-timeout"));
            var d = null;
            if (g) d =
                function() {
                    window.setTimeout(function() {
                        a.animate({
                            top: -e.outerHeight() + "px"
                        }, {
                            duration: 1200
                        })
                    }, g)
            };
            window.setTimeout(function() {
                a.animate({
                    top: 0
                }, {
                    duration: 1200,
                    complete: d
                })
            }, 200)
        }
    }
}

function set_position(l) {
    var g = $("#header");
    g = g.offset().top + g.height() - 11;
    var e = $(window).scrollTop();
    l.css("left", ($(document).width() - l.outerWidth()) / 2 + "px");
    if (e > g) {
        l.css("top", "0px");
        l.css("position", "fixed");
        l.css("z-index", 100)
    } else if (e < g) {
        l.css("position", "absolute");
        l.css("top", g + "px");
        l.css("z-index", 0)
    }
    l.show()
}
