# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$("#users").dataTable
    "bPaginate": true,  #hide pagination control
    "bFilter": true,     #hide filter control
    "bJQueryUI": true

  $("#parents").dataTable
    "bPaginate": true,  #hide pagination control
    "bFilter": true,     #hide filter control
    "bJQueryUI": true

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
