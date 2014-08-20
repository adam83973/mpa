jQuery ->
  $('#stage_list').html('<div class="<%= @stage.name.downcase %> stages well well-lg">
    <h4><u><%= @stage.name %></u></h4>
    <ul>
    <% current_user.location.leads.where("stage_id = ?", "#{ @stage.id }").each do |lead| %>
    <div class="lead_group">
    <div id="lead<%= lead.id %>" data-id="<%= lead.id %>" class="well well-sm" style="z-index:1;">
    <li>
    <div class="row">
    <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
    <%= link_to "#{lead.full_name}", lead%> - Stage: <%= lead.stage.name %>
    </div>
    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
    <%= link_to "javascript:void(0)", class: "stage_attr" do %>
    <i class="fa fa-plus pull-right"></i>
    <% end %>
    </div>
    </div>
    </li>
    </div>
    <div class="lead_toolbar">
    <div class="row">
    <%= simple_form_for [Lead.find(lead.id), Note.new], remote: true do |f| %>
    <%= f.input :content, input_html: { rows: 4, style: "width:100%;" } %>
    <%= f.input :user_id, as: :hidden, input_html: { value: current_user.id } %>
    <%= f.input :lead_id, as: :hidden, input_html: { value: lead.id } %>
    <%= f.button :submit, class: "btn btn-success btn-xs" %>
    <% end %>
    </div>
    </div>
    </div>
    <% end %>
    </ul></br>
    <% if @stage.id == 6 %>
    <p><%= link_to "Add Lead", "#leadModal", data: {toggle: :modal} %></p>
    <% end %>
    </div>')

  $("#new_note")
  .bind 'ajax:beforeSend', (evt, xhr, settings) ->
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