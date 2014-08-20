# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$(document).ready ->
		dial.load()

	$(window).bind "unload", ->
		dial.load()

	$("#student_offering_ids").chosen()
	$("#student_user_id").chosen()

	$('#student_birth_date').datepicker
		dateFormat: 'yy-mm-dd',
		changeMonth: true,
		changeYear:true

	$('#student_start_date').datepicker
    dateFormat: 'yy-mm-dd'

	$('#student_restart_date').datepicker
    dateFormat: 'yy-mm-dd'

	$("#student_start_hold_date").datepicker
		dateFormat: 'yy-mm-dd'

	$('#student_return_date').datepicker
  	dateFormat: 'yy-mm-dd'

	$('#student_end_date').datepicker
    dateFormat: 'yy-mm-dd'
  $('#creditsModal').modal('hide')
  # Passes information to grades modal when modal is launched.
  $('#gradesModalButton').on 'click', ->
    student_id = $('#studentId').data('studentid')
    $('#grade_student_id').val(student_id)
    $('#grade_experience_point_attributes_student_id').val(student_id)
  # Credit form submission events/redeems credits from student's account.
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
    alert "Credits Redeemed! Please note student account with
    credits before purchase, credits spent, and what was redeemed."
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

	# Initiate jQuery Knob
  dial =
		load: ->
			$("#mathematician-dial").knob
		    thickness: ".4"
		    width: "150"
		    height: "150"
		    readOnly: true
		    inputColor: "black"
		    font: "Helvetica"
		    fontWeight: 100
		    fgColor: "#29ABE2"
		    format: ->
		      "L #{$("#mathematician-dial").data("level")}"

		  $("#engineer-dial").knob
		    thickness: ".4"
		    width: "150"
		    height: "150"
		    readOnly: true
		    inputColor: "black"
		    font: "Helvetica"
		    fontWeight: 100
		    fgColor: "#8CC63F"
		    format: ->
		      "L #{$("#engineer-dial").data("level")}"

		  $("#programmer-dial").knob
		    thickness: ".4"
		    width: "150"
		    height: "150"
		    readOnly: true
		    inputColor: "black"
		    font: "Helvetica"
		    fontWeight: 100
		    fgColor: "#F7931E"
		    format: ->
		      "L #{$("#programmer-dial").data("level")}"

  $("#attendanceModal").bind "show", ->
    # enable chosen js
    $('.chosen-select').chosen
      allow_single_deselect: true
      no_results_text: 'No results matched'
      width: '200px'
