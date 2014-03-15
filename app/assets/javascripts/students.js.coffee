# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$("#students_table").dataTable
      "bPaginate": true,  #hide pagination control
      "bFilter": true,     #hide filter control
      "bJQueryUI": true

  $("#inactivestudents").dataTable
      bPaginate: true,  #hide pagination control
      bFilter: true,     #hide filter control
      bJQueryUI: true

  $("#allstudents").dataTable
      bPaginate: true,  #hide pagination control
      bFilter: true,     #hide filter control
      bJQueryUI: true

  $('#student_birth_date').datepicker
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true

  $('#student_start_date').datepicker
    dateFormat: 'yy-mm-dd'

  $('#student_restart_date').datepicker
    dateFormat: 'yy-mm-dd'

  $('#student_return_date').datepicker
    dateFormat: 'yy-mm-dd'

  $('#student_end_date').datepicker
    dateFormat: 'yy-mm-dd'

  $('#creditsModal').modal('hide')

  $('#gradesModalButton').on 'click', ->
    student_id = $('#studentId').data('studentid')
    $('#grade_student_id').val(student_id)
    $('#grade_experience_point_attributes_student_id').val(student_id)

  $("#credits_form")
  .bind 'ajax:beforeSend', (evt, xhr, settings) ->
    $submitButton = $(this).find('input[name="commit"]')
    $studentCredits = parseInt($('#totalCredits').data('totalcredits'))
    $creditsRedeeming = $('#credits_credits').val()
    $submitButton.attr( 'data-origText',  $submitButton.val() )
    $submitButton.val( "Submitting..." )
    if $studentCredits < $creditsRedeeming
      alert 'Student does not have enough credits.'
      xhr.abort()
      $submitButton.val( $submitButton.data('origtext') )
  .bind 'ajax:success', (evt, data, status, xhr) ->
    $form = $(this)
    $form[0].reset()
    alert "Credits Redeemed!"
  .bind 'ajax:complete', (evt, xhr, status) ->
    $submitButton = $(this).find('input[name="commit"]')
    $submitButton.val( $submitButton.data('origtext') )
  .bind 'ajax:error', (evt, xhr, status, error) ->
    $submitButton = $(this).find('input[name="commit"]')
    $submitButton.val( $submitButton.data('origtext') )
    $form = $(this)
    alert "Credits #{error}!"
    $form[0].reset()

  $("type1").height($(".circleBase").height())

  $(".math-dial").knob
    thickness: ".4"
    width: "150"
    height: "150"
    readOnly: true
    inputColor: "black"
    font: "Helvetica"
    fontWeight: 100
    fgColor: "#ffff00"
    format: ->
      "L 99"

  $(".robotics-dial").knob
    thickness: ".4"
    width: "150"
    height: "150"
    readOnly: true
    inputColor: "black"
    font: "Helvetica"
    fontWeight: 100
    fgColor: "#cc0000"
    format: ->
      "L 99"
