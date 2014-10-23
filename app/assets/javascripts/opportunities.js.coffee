# Manage opportunity creation from opportunity modal on admin home
# ---- Opportunity Modal ----------------
# Opportunity creation from home page.
# Once successfully submitted lookup parent modal is launched.
$("#new_opportunity")
.bind 'ajax:beforeSend', (evt, xhr, settings) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.attr( 'data-origText',  $submitButton.val() )
  $submitButton.val( "Submitting..." )
  # Stop submission if parent name is blank
  if !($('#opportunity_parent_name').val()) or $('#opportunity_parent_name').length is 0
    alert "You must enter a parent name."
    $submitButton.val( $submitButton.data('origtext') )
    false
  else if !($('#opportunity_location_id').val())
    alert "You must select a location."
    $submitButton.val( $submitButton.data('origtext') )
    false
  else if !($('#opportunity_parent_phone').val()) and !($('#opportunity_parent_email').val())
    alert "You must an email or phone number for this record."
    $submitButton.val( $submitButton.data('origtext') )
    false
.bind 'ajax:success', (evt, data, status, xhr) ->
  $form = $(this)
  $form[0].reset()
.bind 'ajax:complete', (evt, xhr, status) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.val( $submitButton.data('origtext') )
  $("#opportunityModal").modal('hide')
  #parent lookup modal launched see opportunities/create.js.coffee
.bind 'ajax:error', (evt, xhr, status, error) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.val( $submitButton.data('origtext') )
  $form = $(this)
  alert "Opportunity #{error}!"
  $form[0].reset()

# Reset new opportunity form if form is closed
$("#opportunityModal").on 'show', ->
    $('.opportunity_other_source').hide()

$('#opportunity_source').on 'change', ->
  if $(this).val() is "7"
    $('.opportunity_other_source').show()
  else
    $('.opportunity_other_source').hide()
    $('#opportunity_other_source').val('')

# Reset new opportunity form if form is closed
$("#opportunityModal").on 'hide', ->
  $("#new_opportunity")[0].reset()

# When no match is found user clicks "no match" parent lookup modal is closed and new user modal is opened
$('#opporunityParentNoMatch').on 'click', ->
  $('#parentLookupModal').modal('hide')
  $('#newParentModal').modal('show')
  opportunity_id = $('#parent_lookup_table').data('opportunityid')
  $('#user_opportunity_id').val(opportunity_id)

# When no match is found user clicks "no match" parent lookup modal is closed and new user modal is opened
$('#opporunityStudentNoMatch').on 'click', ->
  $('#addStudentInformationModal').modal('hide')
  $('#studentLookupModal').modal('hide')
  $('#newStudentModal').modal('show')
  opportunity_id = $('#student_lookup_table').data('opportunityid')
  user_id = $('#student_lookup_table').data('userid')
  $('#student_opportunity_id').val(opportunity_id)
  $('#student_user_id').val(user_id)

$('#opporunityStudentUserNoMatch').on 'click', ->
  $('#addStudentInformationModal').modal('hide')
  $('#newStudentModal').modal('show')
  opportunity_id = $(this).data('opportunityid')
  $('#student_opportunity_id').val(opportunity_id)

$('#opporunityUserNoMatch').on 'click', ->
  $('#addUserInformationModal').modal('hide')
  $('#newParentModal').modal('show')
  opportunity_id = $(this).data('opportunityid')
  $('#user_opportunity_id').val(opportunity_id)

$('#addOpportunity').on 'click', ->
  $('#user_location_id').val($('#opportunity_location_id').val())
  $('#user_first_name').val(($('#opportunity_parent_name').val().split(" "))[0])
  $('#user_last_name').val(($('#opportunity_parent_name').val().split(" "))[1])
  $('#user_phone').val($('#opportunity_parent_phone').val())
  $('#user_email').val($('#opportunity_parent_email').val())
  $('#student_first_name').val($('#opportunity_student_name').val())

# Search possible contacts in Infusionsoft and render in table in add parent modal
$('#infusion_id_lookup').on 'click', ->
  $.ajax
    type: 'GET'
    url: "/infusion_pages/possible_contacts"
    data: search: $('#user_last_name').val()
    success: () ->

# Search possible contacts in Infusionsoft and render in table in add parent modal
$('.interest_level').on 'click', ->
  $.ajax
    type: 'GET'
    url: "/opportunities/update_interest"
    data: { id: $(this).data('id'), interest_level: $(this).data('interest-level') }
    success: () ->
      alert "Interest Level Updated"

# Apply chosen to select fields when Opportunity Modal is loaded fix for chosen rendering after modal
$('#opportunityModal').on 'shown.bs.modal', ->
  $('.chosen', this).chosen('destroy').chosen()

$('#oppStudentInformationModal').on 'shown.bs.modal', ->
  $('.chosen', this).chosen('destroy').chosen()

$('#oppClassInformationModal').on 'shown.bs.modal', ->
  $('.chosen', this).chosen('destroy').chosen()

$('#addStudentInformationModal').on 'shown.bs.modal', ->
  $('.chosen', this).chosen('destroy').chosen()

$('#addUserInformationModal').on 'shown.bs.modal', ->
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

$('.panel-heading').find('.add_to_class').on 'click', ->
  $('#addToClassModal').modal('show')
  $('.registration_student').find('select').val($(this).data('studentid'))
  $('.registration_offering').find('select').val($(this).data('offeringid'))
  $('.registration_offering').find('.hidden').val($(this).data('offeringid'))
  $('#registration_opportunity_id').val($(this).data('opportunityid'))

# Convert opportunity to registration from student show.
$('.opportunity_info').find('.add_to_class').on 'click', ->
  $('#addToClassModal').modal('show')
  $('.registration_offering').find('select').val($(this).data('offeringid'))
  $('.registration_offering').find('.hidden').val($(this).data('offeringid'))
  $('.registration_student').find('select').val($(this).data('studentid'))
  $('.registration_student').find('.hidden').val($(this).data('studentid'))
  $('#registration_opportunity_id').val($(this).data('opportunityid'))

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