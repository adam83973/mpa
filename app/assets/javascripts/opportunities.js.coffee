# Toggle opportunity information and actions from student show
$('.opportunity_info_toggle').on "click", ->
    $opp_info = $(this).closest('.well').find('.opportunity_info')
    if $opp_info.css("display") is "none"
      $opp_info.slideDown()
      $(this).find(".fa-chevron-down").removeClass("fa-chevron-down").addClass("fa-chevron-up")
    else
      $opp_info.slideUp()
      $(this).find(".fa-chevron-up").removeClass("fa-chevrone-up").addClass("fa-chevron-down")

# Manage trial date entry based on offering selection. Doesn't allow user to enter trial date
# without selecting offering first.
$opportunity_trial_date = $('#opportunity_trial_date')
$opportunity_offering_id = $('#opportunity_offering_id')

$opportunity_trial_date.on 'change', ->
  if $opportunity_offering_id.val()
  else
    $opportunity_trial_date.val('')
    $opportunity_trial_date.attr("disabled", "disabled")
    $('.opportunity_offering').addClass('has-warning')
    alert "You must select a class offering before adding a trial date."

$opportunity_offering_id.on 'change', ->
  if $opportunity_offering_id.val() and ($opportunity_trial_date.attr("disabled") is "disabled")
    $opportunity_trial_date.removeAttr("disabled")
  else if $opportunity_offering_id.val() is ''
    $opportunity_trial_date.val('')

# Show possible restart if possible restart is selected as status

$opportunity_status = $('#opportunity_status')
$opportunity_possible_restart_date = $('.opportunity_possible_restart_date')

$opportunity_status.on 'change', ->
  if $opportunity_status.val() is '6'
    $opportunity_possible_restart_date.show()
  else
    $opportunity_possible_restart_date.hide()