jQuery ->
  $('#stage_list').html('<div class="<%= @stage.name.downcase %> stages">
    <h4><u><%= @stage.name %></u></h4>
    <ul>
    <% current_user.leads.where("stage_id = ?", "#{ @stage.id }").each do |lead| %>
    <div id="lead<%= lead.id %>" class="ui-draggable" draggable="true" data-id="<%= lead.id %>">
    <li><%= link_to "#{lead.full_name}", lead%> - Stage: <%= lead.stage.name %></li>
    </div>
    <% end %>
    </ul></br>
    <% if @stage.id == 6 %>
    <p><%= link_to "Add Lead", "#leadModal", data: {toggle: :modal} %></p>
    <% end %>
    </div>')

  $('div[id^="lead"]', '#stage_list').draggable ->
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