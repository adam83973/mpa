$('#opportunities_by_status').html('<div class="well well-lg">
    <h4><u><%= Opportunity::STATUSES[@old_status.to_i] %></u></h4>
    <ul>
    <% current_user.location.opportunities.where("status = ?", "#{ @old_status }").each do |opp| %>
    <%= escape_javascript(render "/shared/lead_group", opportunity: opp) %>
    <% end %>
    </ul>
    </div>')

$("#stage_droppable").html('<%= escape_javascript(render "/static_pages/droppable_stages") %>')

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

$('#opportunities_by_status').find('.opportunity_toolbar').each ->
  $(this).css("display", "none")

$('.status_attr').on "click", ->
  $opportunity_toolbar = $(this).closest('.opportunity_group').find('.opportunity_toolbar')
  if $opportunity_toolbar.css("display") is "none"
    $opportunity_toolbar.slideDown()
    $opportunity_toolbar.find('input[id^="note_action_date"]').datepicker
      dateFormat: 'yy-mm-dd',
      changeMonth: true,
      changeYear:true
  else
    $opportunity_toolbar.slideUp()

$('div[id^="opportunity"]', '#opportunities_by_status').each ->
  $(this).draggable
    revert: "invalid"
$(".opportunity_statuses").droppable drop: (event, ui) ->
  $dropP = $(this).find("p")
  $dropP.html( "Opportunity Updated!" )
  drop.update($(this).data('status'),$(ui.draggable).data('id'))
  $(ui.draggable).empty().remove()
  setTimeout ->
    $dropP.fadeOut()
  , 2000

$('.opportunity_statuses').on 'click', 'a', ->
  status.select($(this).data("status"))

status=
  select: (status) ->
    $.ajax
      type: 'GET'
      url: "/opportunities/by_status"
      data: {status: status}

drop =
  #ajax call to update lead stage
  update: (new_status_id, opportunity_id) ->
    $.ajax
      type: 'POST'
      url: "/opportunities/update_status"
      data: { id: opportunity_id, status: new_status_id }
      success: (result) ->