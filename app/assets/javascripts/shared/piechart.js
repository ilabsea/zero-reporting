$(function(){
  if($('#piechart-review').length > 0)
  	drawChart();
})

function drawChart(){
	var piechartReview = $('#piechart-review').css({'width':'90%' , 'min-height':'150px'});
	var piechartPHD = $('#piechart-phd').css({'width':'90%' , 'min-height':'150px'});
	var request = $.ajax({
	  method: "GET",
	  url: location.origin + "/reports/" + "query_piechart" + location.search
	});
	request.done(function(data) {
		drawPieChart(piechartReview, data["review"]);
		drawPieChart(piechartPHD, data["phd"]);
	});
 
	request.fail(function( jqXHR, textStatus ) {
  	alert( "Faild to get data for piechart");
	});
}

function drawPieChart(placeholder, data, position) {
  $.plot(placeholder, data, {
		series: {
			pie: {
				show: true,
				tilt:0.8,
				highlight: {
					opacity: 0.25
				},
				stroke: {
					color: '#fff',
					width: 2
				},
				startAngle: 2
			}
		},
		legend: {
			show: true,
			position: position || "ne", 
			labelBoxBorderColor: null,
			margin:[-30,15]
		}
		,
		grid: {
			hoverable: true,
			clickable: true
		}
	})
}