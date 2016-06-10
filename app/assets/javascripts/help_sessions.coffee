# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  # toggle disabled on button to prevent user from starting session without student
  $('#help_session_student_id').on 'change', ->
    if $(this).val() == ""
      $('#start-hw-help').prop('disabled', true)
    else
      $('#start-hw-help').prop('disabled', false)

  $('#launchLearningPlanModal').on 'click', ->
    $('#learningPlanModal').modal('show')

  $('#exampleModal').on 'show', ->
    $('#learning_plan_course_id').chosen
      allow_single_deselect: true
