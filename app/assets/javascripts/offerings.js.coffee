# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery -> 
  $('#offerings').dataTable
  		"bJQueryUI": true
  

jQuery -> 
        oTable = $('#example').dataTable
        "bJQueryUI": true,
        "sScrollY": "300px",
        "sScrollX": "100%",
        "sScrollXInner": "150%",
        "bScrollCollapse": true,
        "bPaginate": false

    new FixedColumns( oTable )

		 		
		 		