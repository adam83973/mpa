$('#lessons').dataTable()
$('#lesson_assignment').chosen()
$('#lesson_assignment_key').chosen()
$('#lesson_problem_ids').chosen()
$('#lesson_resource_ids').chosen()

$("[name='lesson-error']").bootstrapSwitch
	onText: 		'Contains Errors',
	offText: 		'No Errors',
	onColor: 		'danger',
	offColor: 	'success'

alert

$('input[name="lesson-error"]').on 'switchChange.bootstrapSwitch', (event, state) ->

	$.ajax
		url: '/lessons/toggle_error',
		data: lesson: { id: $(this).data('lessonid'), contains_error: state }
		success: (data) ->
			console.log data
