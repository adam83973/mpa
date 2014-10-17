# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('.registration_info_toggle').on "click", ->
    $note_info = $(this).closest('.well').find('.registration_info')
    if $note_info.css("display") is "none"
      $note_info.slideDown()
      $(this).find(".fa-chevron-down").removeClass("fa-chevron-down").addClass("fa-chevron-up")
    else
      $note_info.slideUp()
      $(this).find(".fa-chevron-up").removeClass("fa-chevrone-up").addClass("fa-chevron-down")

$('.registration_info').find('.switch').on 'click', ->
  $('#registrationSwitchModal').modal('show')
  $('#switch_registration_id').val($(this).data('registrationid'))

$('.registration_info').find('.drop').on 'click', ->
  if confirm "This action will remove #{$(this).data("studentfirstname")} from #{$(this).data("offeringname")} on the date you specify.\n \n You will be asked to enter an end date after confirming.\n \n Are you sure you want to continue?"
    $('#registrationDropModal').modal('show')
    $('#drop_registration_id').val($(this).data('registrationid'))

$('.registration_info').find('.hold').on 'click', ->
  if confirm "Do you want to place this registration on hold?\n\n You will need to know when the hold will begin and when the student will return."
    $('#registrationHoldModal').modal('show')
    $('#hold_registration_id').val($(this).data('registrationid'))

$('#registrationSwitchModal').on 'shown.bs.modal', ->
  $('.chosen', this).chosen('destroy').chosen()