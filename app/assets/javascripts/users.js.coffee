# User Form View
$("#user_role").on "change", ->
	if $(this).val() is "Parent"
		$(".user_passion").hide()
		$(".user_shirt_size").hide()
		$(".user_has_key").hide()
		$(".user_admin").hide()
	else
		$(".user_infusion_id").hide()
		$(".user_passion").show()
		$(".user_shirt_size").show()
		$(".user_has_key").show()
		$(".user_admin").show()

$("#user_role").on "change", ->
	if !($(this).val() is "Admin")
		$(".user_admin").hide()
	else
		$(".user_admin").show()

$("#new_user")
.bind 'ajax:beforeSend', (evt, xhr, settings) ->
  $submitButton = $(this).find('input[name="commit"]')
  $submitButton.attr( 'data-origText',  $submitButton.val() )
  $submitButton.val( "Submitting..." )
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
