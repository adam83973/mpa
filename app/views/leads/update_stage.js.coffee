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

  $("#stage_droppable").html(
    '<div class="leads well well-sm text-center" id="appointment_scheduled">
    <%= link_to "javascript:void(0)", data: { stageid: 1 } do %>
    <h4>Appointments Scheduled: <span><%= Lead.active_stage_count("Appointment Scheduled", current_user.location_id)%></span></h4>
    <% end %>
    <p></p>
    </div><!-- /.leads -->
    <div class="leads well well-sm text-center" id="appointment_missed">
    <%= link_to "javascript:void(0)", data: { stageid: 7 } do %>
    <h4>Appointments Missed: <span><%= Lead.active_stage_count("Appointment Missed", current_user.location_id)%></span></h4>
    <% end %>
    <p></p>
    </div><!-- /.leads -->
    <div class="leads well well-sm text-center" id="assessment_completed">
    <%= link_to "javascript:void(0)", data: { stageid: 2 } do %>
    <h4>Assessments Completed: <span><%= Lead.active_stage_count("Assessment Completed", current_user.location_id)%></span></h4>
    <% end %>
    <p></p>
    </div><!-- /.leads -->
    <div class="leads well well-sm text-center" id="trial_offered">
    <%= link_to "javascript:void(0)", data: { stageid: 3 } do %>
    <h4>Trial Offered: <span><%= Lead.active_stage_count("Trial Offered", current_user.location_id)%></span></h4>
    <% end %>
    <p></p>
    </div><!-- /.leads -->
    <div class="leads well well-sm text-center" id="won">
    <h4><u>Won</u></h4>
    <p></p>
    </div><!-- /.leads -->
    <div class="leads well well-sm text-center" id="lost">
    <h4><u>Lost</u></h4>
    <p></p>
    </div><!-- /.leads -->')

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
      $( ".datepicker" ).datepicker
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

  $('.leads').on 'click', 'a', ->
    stage.select($(this).data("stageid"))

stage=
  select: (stage_id) ->
    $.ajax
      type: 'GET'
      url: "/leads/stage_list"
      data: {stage_id: stage_id}

drop =
  update: (dragged_id, received_id) ->
    $.ajax
      type: 'POST'
      url: "/leads/update_stage"
      data: { id: received_id, stage: dragged_id }
      success: (result) ->