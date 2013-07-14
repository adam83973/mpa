# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$("#students").dataTable
      bPaginate: true,  #hide pagination control
      bFilter: true,     #hide filter control
      bJQueryUI: true

jQuery ->
  $("#inactivestudents").dataTable
      bPaginate: true,  #hide pagination control
      bFilter: true,     #hide filter control
      bJQueryUI: true

jQuery ->
  $("#allstudents").dataTable
      bPaginate: true,  #hide pagination control
      bFilter: true,     #hide filter control
      bJQueryUI: true

    $('#student_birth_date').datepicker
      dateFormat: 'yy-mm-dd'
    $('#student_start_date').datepicker
        dateFormat: 'yy-mm-dd'
    $('#student_restart_date').datepicker
        dateFormat: 'yy-mm-dd'
    $('#student_return_date').datepicker
        dateFormat: 'yy-mm-dd'

