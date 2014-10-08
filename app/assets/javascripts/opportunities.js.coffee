# Manage opportunity creation from opportunity modal on admin home
# ---- Opportunity Modal ----------------
# Handle opportunity ajax events ---
$("#new_opportunity")
.bind 'ajax:beforeSend', (evt, xhr, settings) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.attr( 'data-origText',  $submitButton.val() )
  $submitButton.val( "Submitting..." )
.bind 'ajax:success', (evt, data, status, xhr) ->
  $form = $(this)
  $form[0].reset()
  alert "Lead Added!"
  setTimeout ->
    location.reload()
  , 1000
.bind 'ajax:complete', (evt, xhr, status) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.val( $submitButton.data('origtext') )
  $("#opportunityModal").modal('hide')
.bind 'ajax:error', (evt, xhr, status, error) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.val( $submitButton.data('origtext') )
  $form = $(this)
  alert "Opportunity #{error}!"
  $form[0].reset()

# Apply chosen to select fields when Opportunity Modal is loaded
$('#opportunityModal').on 'shown.bs.modal', ->
  $('.chosen', this).chosen('destroy').chosen()

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

# Show possible restart date field if possible restart is selected as status
$opportunity_status = $('#opportunity_status')
$opportunity_possible_restart_date = $('.opportunity_possible_restart_date')

$opportunity_status.on 'change', ->
  if $opportunity_status.val() is '6'
    $opportunity_possible_restart_date.show()
  else
    $opportunity_possible_restart_date.hide()

# Hide Show Opportunity Note Form
$('.status_attr').on "click", ->
  $opportunity_toolbar = $(this).closest('.opportunity_group').find('.opportunity_toolbar')
  if $opportunity_toolbar.css("display") is "none"
    $(this).find('.fa').removeClass('fa-plus').addClass('fa-minus')
    $opportunity_toolbar.slideDown()
    $opportunity_toolbar.find('input[id^="note_action_date"]').datepicker
      dateFormat: 'yy-mm-dd',
      changeMonth: true,
      changeYear:true
  else
    $opportunity_toolbar.slideUp()
    $(this).find('.fa').removeClass('fa-minus').addClass('fa-plus')