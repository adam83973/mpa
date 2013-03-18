# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery -> 
  $('#offerings').dataTable
  		"bJQueryUI": true
  
jQuery -> 
  $('#example').dataTable
        "bJQueryUI": true
        "sScrollX": "100%",
        "sScrollXInner": "150%",
        "bScrollCollapse": true,
        "bPaginate": false





