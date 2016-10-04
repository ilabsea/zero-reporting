function showElement(elementId) {
  $(elementId).show();
}

function hideElement(elementId) {
  $(elementId).hide();
}

function toggleChildElement(elementId, childElementId) {
  $(elementId).is(':checked') ? showElement(childElementId) : hideElement(childElementId);
}
