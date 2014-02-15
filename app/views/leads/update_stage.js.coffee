jQuery ->
  $('.new_leads').find('ul').append('<div id="lead<%= @lead.id %>" draggable="true" class="ui-draggable" data-id="<%= @lead.id %>">
  <li><%= link_to "#{@lead.full_name}", @lead%> - Stage: <%= @lead.stage.name %></li>
  </div>')

  $('div[id^="lead"]').draggable ->
    $dragged = $(this)
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



