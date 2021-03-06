# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
	dial.load()

$(window).bind "unload", ->
	dial.load()

# When prize redemption modal is launched, levels modal is hidden.

$('.redeem-prize').on 'click', ->
	$('#mathematicianModal').modal('hide')
	$('#programmerModal').modal('hide')
	$('#engineerModal').modal('hide')
	$('#prizeRedemptionModal').find('#prize-name').text($(this).data('prizename'))
	$('#transaction_occupation_level_id').val($(this).data('levelid'))


$('#prizeRedemptionModal').on 'shown.bs.modal', ->
	$('.chosen', this).chosen('destroy').chosen()

$('#prizeRedemptionModal').on 'hidden.bs.modal', ->
	$(this).find('form')[0].reset()
	$('#transaction_product_id').prop('disabled', true).trigger("chosen:updated")

$("#student_offering_ids").chosen()

$('.birth-date').datepicker
	dateFormat: 'yy-mm-dd',
	changeMonth: true,
	changeYear:true

# Adds datepicker to student end date field
$('#student_end_date').datepicker
  dateFormat: 'yy-mm-dd'

# $('#creditsModal').modal('hide')

# Passes information to grades modal when modal is launched.
$('#gradesModalButton').on 'click', ->
  student_id = $('#studentId').data('studentid')
  $('#grade_student_id').val(student_id)
  $('#grade_experience_point_attributes_student_id').val(student_id)

$('#creditsModal').on 'shown.bs.modal', ->
  $('.chosen', this).chosen('destroy').chosen()

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
  alert "Credits Redeemed! A note has been added to this student's account recording this transaction."
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
	    thickness: ".2"
	    width: "125"
	    height: "125"
	    readOnly: true
	    inputColor: "black"
	    font: "Helvetica"
	    fontWeight: 100
	    fgColor: "#7d2622"

	  $("#engineer-dial").knob
	    thickness: ".2"
	    width: "125"
	    height: "125"
	    readOnly: true
	    inputColor: "black"
	    font: "Helvetica"
	    fontWeight: 100
	    fgColor: "#470c5f"

	  $("#programmer-dial").knob
	    thickness: ".2"
	    width: "125"
	    height: "125"
	    readOnly: true
	    inputColor: "black"
	    font: "Helvetica"
	    fontWeight: 100
	    fgColor: "#f77c32"
      #set delay to allow dom elements to load
    setTimeout ( ->
      $("#mathematician-dial").parent("div").addClass("outside")
      $("#engineer-dial").parent("div").addClass("outside")
      $("#programmer-dial").parent("div").addClass("outside")
    ), 100
