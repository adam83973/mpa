# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
	dial.load()

$(window).bind "unload", ->
	dial.load()

$("#student_offering_ids").chosen()

$('#student_birth_date').datepicker
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

# Listener on location field for credits modal to update products available at selected location
$('#transaction_location_id').on 'change', ->
	alert $(this).val()

	$.ajax
		type:'get',
		url: 'http://localhost:3000/products/products_by_location.json'
		data: {location_id: $(this).val()}
		success: (data, status, xhr) ->
			console.log data
			products = data
			$.each data, (index, value) ->
				$('#transaction_product_id').append($("<option></option>").attr("data-credits", value[2]).attr("value", value[0]).text(value[1]))
			$(".transaction_product").find(".chosen-disabled").removeClass("chosen-disabled")
			$('#transaction_product_id').removeClass("disabled").prop('disabled', false)
			$('#transaction_product_id').chosen('destroy').chosen()
		error: (xhr, status, e) ->
		dataType: 'JSON'


$("type1").height($(".circleBase").height())

# Initiate jQuery Knob
dial =
	load: ->
		$("#mathematician-dial").knob
	    thickness: ".2"
	    width: "150"
	    height: "150"
	    readOnly: true
	    inputColor: "black"
	    font: "Helvetica"
	    fontWeight: 100
	    fgColor: "#7d2622"

	  $("#engineer-dial").knob
	    thickness: ".2"
	    width: "150"
	    height: "150"
	    readOnly: true
	    inputColor: "black"
	    font: "Helvetica"
	    fontWeight: 100
	    fgColor: "#470c5f"

	  $("#programmer-dial").knob
	    thickness: ".2"
	    width: "150"
	    height: "150"
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

$("#attendanceModal").bind "show", ->
  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '200px'
