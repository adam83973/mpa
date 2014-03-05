jQuery ->
  $('#stage_list').html('<div class="<%= @stage.name.downcase %> stages">
    <h4><u><%= @stage.name %></u></h4>
    <ul>
    <% current_user.location.leads.where("stage_id = ?", "#{ @stage.id }").each do |lead| %>
    <div class="lead_group">
    <div id="lead<%= lead.id %>" data-id="<%= lead.id %>">
    <li>
    <div class="row">
    <div class="span3">
    <%= link_to "#{lead.full_name}", lead%> - Stage: <%= lead.stage.name %>
    </div>
    <%= link_to "javascript:void(0)", class: "stage_attr" do %>
    <i class="icon icon-plus pull-right"></i>
    <% end %>
    </div>
    </li>
    </div>
    <div class="lead_toolbar">
    <div class="row">
    <%= simple_form_for [Lead.find(lead.id), Note.new], remote: true do |f| %>
    <%= f.input :content, input_html: { rows: 0, cols: 0 } %>
    <%= f.input :user_id, as: :hidden, input_html: { value: current_user.id } %>
    <%= f.input :lead_id, as: :hidden, input_html: { value: lead.id } %>
    <%= f.button :submit, class: "m-btn note-button green" %>
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

  $("#stage_droppable").html(
    '<div class="leads" id="appointment_scheduled">
    <h4><u>Appointment Scheduled: <span><%= Lead.active_stage_count("Appointment Scheduled", current_user.location_id)%></span></u></h4>
    <p></p>
    </div>
    <div class="leads" id="appointment_missed">
    <h4><u>Appointment Missed: <span><%= Lead.active_stage_count("Appointment Missed", current_user.location_id)%></span></u></h4>
    <p></p>
    </div>
    <div class="leads" id="assessment_completed">
    <h4><u>Assessment Completed: <span><%= Lead.active_stage_count("Assessment Completed", current_user.location_id)%></span></u></h4>
    <p></p>
    </div>
    <div class="leads" id="trial_offered">
    <h4><u>Trial Offered: <span><%= Lead.active_stage_count("Trial Offered", current_user.location_id)%></span></u></h4>
    <p></p>
    </div>
    <div class="leads" id="won">
    <h4><u>Won</u></h4>
    <p></p>
    </div>
    <div class="leads" id="lost">
    <h4><u>Lost</u></h4>
    <p></p>
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