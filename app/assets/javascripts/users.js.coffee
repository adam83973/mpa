# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$("#users").dataTable
    "bPaginate": true,  #hide pagination control
    "bFilter": true,     #hide filter control
    "bJQueryUI": true

  $("#parents").dataTable
    "bPaginate": true,  #hide pagination control
    "bFilter": true,     #hide filter control
    "bJQueryUI": true