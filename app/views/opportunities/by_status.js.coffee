jQuery ->
  $('#opportunities_by_status').html('<div class="card">
    <div class="card-block">
    <h4><u><%= Opportunity::STATUSES[@status.to_i] %></u></h4>
    <ul>
    <% @user_location.opportunities.where("status = ?", "#{ @status }").each do |opp| %>
    <%= escape_javascript(render "/shared/lead_group", opportunity: opp) %>
    <% end %>
    </ul>
    </div>
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

  $('#opportunities_by_status').find('.opportunity_toolbar').each ->
    $(this).css("display", "none")

  # Hide Show Opportunity Note Form
  $('.status_attr').on "click", ->
    $opportunity_toolbar = $(this).closest('.opportunity_group').find('.opportunity_toolbar')
    if $opportunity_toolbar.css("display") is "none"
      $(this).find('.fa').removeClass('fa-plus').addClass('fa-minus')
      $opportunity_toolbar.slideDown()
      $opportunity_toolbar.find('input[id^="note_action_date"]').datepicker
        dateFormat: 'yy-mm-dd',
        changeMonth: true,
        changeYear:true
    else
      $opportunity_toolbar.slideUp()
      $(this).find('.fa').removeClass('fa-minus').addClass('fa-plus')

  $('div[id^="opportunity"]', '#opportunities_by_status').each ->
    $(this).draggable
      cursor: 'move',
      revert: (dropped) ->
        if dropped
          false
        else
          $(".opportunity_statuses"). each ->
            $dropP = $(this).find("p")
            setTimeout ->
              $dropP.fadeOut()
            , 3000
            false


  $(".opportunity_statuses").droppable
    drop: (event, ui) ->
      #check to see if trial date has been entered before moving to trial status
      $new_status_id = $(this).data('status')
      $opportunity = $(ui.draggable)
      $dropP = $(this).find("p")
      drop.success($new_status_id, $opportunity, $dropP)
    accept: (dropElem) ->
      $new_status_id = $(this).data('status')
      $dropP = $(this).find("p")
      switch $new_status_id
        when 1
          if dropElem.data("appointmentdate")
            true
          else
            $dropP.html( "You must enter an appointment date!" )
            false
        when 3
          if dropElem.data("trialdate")
            true
          else
            $dropP.html( "You must enter a trial date!" )
            false
        else
          true

drop =
  #ajax call to update opportunity status
  update: (new_status_id, opportunity_id) ->
    $.ajax
      type: 'POST'
      url: "/opportunities/update_status"
      data: { id: opportunity_id, status: new_status_id }
      success: (result) ->
  success: (new_status_id, opportunity, dropP) ->
      dropP.html( "Opportunity Updated!" )
      drop.update(new_status_id, opportunity.data('id'))
      opportunity.empty().remove()
      setTimeout ->
        dropP.fadeOut()
      , 2000
