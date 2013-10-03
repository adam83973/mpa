# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$("#activities").dataTable
      "bPaginate": true,  #hide pagination control
      "bFilter": true,     #hide filter control
      "bJQueryUI": true

  $('#activity_resource_ids').chosen()
	$('#activity_standard_ids').chosen()