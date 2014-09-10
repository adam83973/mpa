jQuery ->
  $('#stage_list').html('<div class="<%= @stage.name.downcase %> stages well well-lg">
    <h4><u><%= @stage.name %></u></h4>
    <ul>
    <% current_user.location.leads.where("stage_id = ?", "#{ @stage.id }").each do |lead| %>
    <%= escape_javascript(render "/shared/lead_group", lead: lead) %>
    <% end %>
    </ul></br>
    <% if @stage.id == 6 %>
    <p><%= link_to "Add Lead", "#leadModal", data: {toggle: :modal} %></p>
    <% end %>
    </div>')

  $(".new_note").each ->
    $(this).bind 'ajax:beforeSend', (evt, xhr, settings) ->
      $submitButton = $(this).find('input[name="commit"]')
      $submitButton.attr( 'data-origText',  $submitButton.val() )
      $submitButton.val( "Submitting..." )
    .bind 'ajax:success', (evt, data, status, xhr) ->
      $form = $(this)
      $form[0].reset()
      alert "Note Added!"
    .bind 'ajax:complete', (evt, xhr, status) ->
      $submitButton = $(this).find('input[name="commit"]')
      $submitButton.val( $submitButton.data('origtext') )
      $lead_toolbar = $(this).closest('.lead_group').find('.lead_toolbar')
      $lead_toolbar.slideUp()
    .bind 'ajax:error', (evt, xhr, status, error) ->
      $submitButton = $(this).find('input[name="commit"]')
      $submitButton.val( $submitButton.data('origtext') )
      $form = $(this)
      alert "Note #{error}!"
      $form[0].reset()

  $('#stage_list').find('.lead_toolbar').each ->
    $(this).css("display", "none")

  $('.stage_attr').on "click", ->
    $lead_toolbar = $(this).closest('.lead_group').find('.lead_toolbar')
    if $lead_toolbar.css("display") is "none"
      $lead_toolbar.slideDown()
      $lead_toolbar.find('input[id^="note_action_date"]').datepicker
        dateFormat: 'yy-mm-dd',
        changeMonth: true,
        changeYear:true
    else
      $lead_toolbar.slideUp()

  $('div[id^="lead"]', '#stage_list').each ->
    $(this).draggable
      revert: "invalid"
  $(".leads").droppable drop: (event, ui) ->
    $dropP = $(this).find("p")
    $dropP.html( "Lead Updated!" )
    drop.update($(this).attr('id'),$(ui.draggable).data('id'))
    $(ui.draggable).empty().remove()
    setTimeout ->
      $dropP.fadeOut()
    , 2000

drop =
  update: (dragged_id, received_id) ->
    $.ajax
      type: 'POST'
      url: "/leads/update_stage"
      data: { id: received_id, stage: dragged_id }
      success: (result) ->