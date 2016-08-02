// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
	init();
});

function init() {
	var $addMore = $("div > .btn-add-more");
	$addMore.on('click', function() {
		var parentElement = $("div.event_attachments");
		var element = buildChildElement(parentElement.length);
		addElementTo(element, parentElement);
	});
};

function addElementTo(element, parent) {
	$(parent).append(element);
};

function buildChildElement(index) {
	var div = $("<div>");
	div.addClass("form-group file optional event_attachments_file");
	var label = $("<label class='file optional control-label' for='event_attachments_attributes_" + index + "_file'>&nbsp;</label>");
	div.append(label);
	var input = $("<input style='display:inline;' class='file optional' type='file' name='event[attachments_attributes][" + index + "][file]' id='event_attachments_attributes_" + index + "_file'>");
	div.append(input);

	return div;
};
