$('#help_session_student_id').on 'change', ->
  if $(this).val() == ""
    $('#start-hw-help').prop('disabled', true)
  else
    if $('#help_session_date').val() == ""
      $('#start-hw-help').prop('disabled', true)
    else
      $('#start-hw-help').prop('disabled', false)

$('#help_session_date').on 'change', ->
  if $(this).val() == ""
    $('#start-hw-help').prop('disabled', true)
  else
    if $('#help_session_student_id').val() == ""
      $('#start-hw-help').prop('disabled', true)
    else
      $('#start-hw-help').prop('disabled', false)

$('#launchLearningPlanModal').on 'click', ->
  $('#learningPlanModal').modal('show')

$('#exampleModal').on 'show', ->
  $('#learning_plan_course_id').chosen
    allow_single_deselect: true
