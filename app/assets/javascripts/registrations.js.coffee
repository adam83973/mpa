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

$('#registrationSwitchModal').on 'shown.bs.modal', ->
  $('.chosen', this).chosen('destroy').chosen()