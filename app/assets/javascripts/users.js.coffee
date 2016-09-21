# User Form View
$user_ssn = $('.user_ssn')
$user_bank_account = $('.user_bank_account')
$user_routing_number = $('.user_routing_number')
$user_shirt_size = $(".user_shirt_size")
$user_passion = $(".user_passion")
$user_has_key = $(".user_has_key")
$user_admin = $(".user_admin")
$user_billing_note = $('.user_billing_note')
$user_infusion_id = $(".user_infusion_id")
$user_address = $(".user_address")
$user_city = $(".user_city")
$user_state = $(".user_state")
$user_zip = $(".user_zip")
$user_exemptions = $(".user_exemptions")

if $("#user_role").val() in ["Teacher", "Admin", "Teaching Assitant", "Robotics Instructor", "Programming Instrutor", "Chess Instructor"]
	$user_passion.show()
	$user_shirt_size.show()
	$user_has_key.show()
	$user_ssn.show()
	$user_bank_account.show()
	$user_routing_number.show()
	$user_exemptions.show()
	if $("#user_role").val() is "Admin"
		$user_admin.show()
else if $('#user_role').val() is "Parent"
	$user_billing_note.show()
	$user_infusion_id.show()

$("#user_role").on "change", ->
	if $(this).val = "Admin"
		$('#user_admin').prop('checked', true)
	else
		$('#user_admin').prop('checked', false)

	if $(this).val() is "Parent"
		$user_shirt_size.hide()
		$('#user_shirt_size').val('')
		$user_has_key.hide()
		$('#user_has_key').prop('checked', false)
		$user_admin.hide()
		$('#user_admin').prop('checked', false)
		$user_ssn.hide()
		$user_ssn.find('#user_ssn').val('')
		$user_bank_account.hide()
		$('#user_bank_account').val('')
		$user_routing_number.hide()
		$('#user_routing_number').val('')
		$user_passion.hide()
		$('#user_passion').val('')
		$user_exemptions.hide()
		$('#user_exemptions').val('')
		$user_billing_note.show()
		$user_infusion_id.show()
	else
		$user_infusion_id.hide()
		$('#user_infusion_id').val('')
		$user_billing_note.hide()
		$('#user_billing_note').val('')
		$user_passion.show()
		$user_shirt_size.show()
		$user_has_key.show()
		$user_admin.show()
		$user_ssn.show()
		$user_bank_account.show()
		$user_routing_number.show()
		$user_exemptions.show()

$("#user_role").on "change", ->
	if !($(this).val() is "Admin")
		$(".user_admin").hide()
	else
		$(".user_admin").show()

$user_ssn = $('.user_ssn')
$user_bank_account = $('.user_bank_account')
$user_routing_number = $('.user_routing_number')

$('#user_role').on 'change', ->
	if $(this).val() != "Parent"
	else
		$user_ssn.hide()
		$user_bank_account.hide()
		$user_routing_number.hide()

$("#new_user")
.bind 'ajax:beforeSend', (evt, xhr, settings) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.attr( 'data-origText',  $submitButton.val() )
  $submitButton.val( "Submitting..." )
  if !($('#user_email').val())
    if confirm "If you do not have an email you cannot link this parent or a student to this opportunity.
    \n \n
    Would you like to create this opportunity without linking a parent? You can add a parent to the app at a later time."
      $submitButton.val( $submitButton.data('origtext') )
      $form = $(this)
      $form[0].reset()
      $('#newParentModal').modal('hide')
      alert "Opportunity created!"
      false
      location.reload()
  else if !($('#user_first_name').val()) and !($('#user_last_name').val())
    alert "You must enter a first and last name."
    $submitButton.val( $submitButton.data('origtext') )
    false
  else if !($('#user_infusion_id').val()) or $('#user_infusion_id').length is 0
    alert "You must link with an Infusionsoft contact. If there is not one to be linked you can add the parent to Infusionsoft."
    $submitButton.val( $submitButton.data('origtext') )
    false
.bind 'ajax:success', (evt, data, status, xhr) ->
  $form = $(this)
  $form[0].reset()
.bind 'ajax:complete', (evt, xhr, status) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.val( $submitButton.data('origtext') )
.bind 'ajax:error', (evt, xhr, status, error) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.val( $submitButton.data('origtext') )
  $form = $(this)
  alert "User #{error}!"

	$("#new_user_from_opportunity")
	.bind 'ajax:beforeSend', (evt, xhr, settings) ->
	  $submitButton = $(this).find('input[name="commit"]')
	  $submitButton.attr( 'data-origText',  $submitButton.val() )
	  $submitButton.val( "Submitting..." )
	  if !($('#user_email').val())
	    alert "You must have an email in order to add this parent."
	    $submitButton.val( $submitButton.data('origtext') )
	    false
	  else if !($('#user_first_name').val()) and !($('#user_last_name').val())
	    alert "You must enter a first and last name."
	    $submitButton.val( $submitButton.data('origtext') )
	    false
	  else if !($('#user_infusion_id').val()) or $('#user_infusion_id').length is 0
	    alert "You must link with an Infusionsoft contact. If there is not one to be linked you can add the parent to Infusionsoft."
	    $submitButton.val( $submitButton.data('origtext') )
	    false
	.bind 'ajax:success', (evt, data, status, xhr) ->
	  $form = $(this)
	  $form[0].reset()
	.bind 'ajax:complete', (evt, xhr, status) ->
	  $submitButton = $(this).find('input[name="commit"]')
	  $submitButton.val( $submitButton.data('origtext') )
	.bind 'ajax:error', (evt, xhr, status, error) ->
	  $submitButton = $(this).find('input[name="commit"]')
	  $submitButton.val( $submitButton.data('origtext') )
	  $form = $(this)
	  alert "User #{error}!"

# Search possible contacts in Infusionsoft and render in table in add parent modal
$('.infusion_id_lookup').on 'click', ->
  $.ajax
    type: 'GET'
    url: "/infusion_pages/possible_contacts"
    data:
      search: $(this).data('lastname')
      UserId: $(this).data('userid')
    success: () ->
