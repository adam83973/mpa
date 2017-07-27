$('#infusionsoft_results').html('<%= escape_javascript(render "/infusion_pages/possible_contacts_table") %>').css("margin-top", "10px")

$('.infusionsoft_results').html('<%= j render "/infusion_pages/possible_contacts_table_show" if @user %>').css("margin-top", "10px")

$('#infusionsoft_results').on 'click', 'a', ->
  if $('#user_infusion_id').val($(this).data('id'))
    $('#infusionsoft_results').html('')
    alert "Infusionsoft ID added to Parent."
  else
    alert "No ID added please create a contact in Infusionsoft or add an ID."

$('#infusionsoft_create_contact').on 'click', ->
  if confirm("Are you sure you want to add this parent to Infusionsoft?")
    $.ajax
      type: 'GET'
      url: "/infusion_pages/add_contact"
      dataType: 'json'
      data:
        FirstName: $('#user_first_name').val()
        LastName: $('#user_last_name').val()
        Email: $('#user_email').val()
      success: (data, textStatus, xhr) ->
        alert "Parent added to Infusionsoft."
        $('#user_infusion_id').val(data)
        $('#infusion_id_lookup').hide()
        $('#infusionsoft_results').hide()

# When searching Infusionsoft from User show page, link Infusionsoft contact with parent account.
$('.possible_contacts').on 'click', 'a', ->
  if confirm("Are you sure you want to link this parent and this Infusionsoft contact?")
    $.ajax
      type: 'GET'
      url: "/infusion_pages/add_existing_id"
      dataType: 'json'
      data:
        UserId: $('.infusion_id_lookup').data('userid')
        Id: $(this).data('id')
      success: (data, textStatus, xhr) ->
        alert "Parent linked to Infusionsoft contact."
        location.reload()

$('.infusionsoft_create_contact').on 'click', ->
  if confirm("Are you sure you want to add this parent to Infusionsoft?")
    $.ajax
      type: 'GET'
      url: "/infusion_pages/add_contact"
      dataType: 'json'
      data:
        FirstName: $(this).data('firstname')
        LastName: $(this).data('lastname')
        Email: $(this).data('email')
        Show: true
        UserId: $(this).data('userid')
      success: (data, textStatus, xhr) ->
        alert "Parent added to Infusionsoft."
        location.reload()
