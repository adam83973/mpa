# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('.opportunity_info_toggle').on "click", ->
    $opp_info = $(this).closest('.well').find('.opportunity_info')
    if $opp_info.css("display") is "none"
      $opp_info.slideDown()
      $(this).find(".fa-chevron-down").removeClass("fa-chevron-down").addClass("fa-chevron-up")
    else
      $opp_info.slideUp()
      $(this).find(".fa-chevron-up").removeClass("fa-chevrone-up").addClass("fa-chevron-down")