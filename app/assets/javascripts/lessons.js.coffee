# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('#lessons').dataTable()
	$('#lesson_assignment').chosen()
	$('#lesson_assignment_key').chosen()
	$('#lesson_problem_ids').chosen()
	$('#lesson_resource_ids').chosen()
