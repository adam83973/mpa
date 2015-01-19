jQuery ->
  ignoreDrag = (e) ->
    e.originalEvent.stopPropagation()
    e.originalEvent.preventDefault()

  onDrop = (e) ->
    e.preventDefault()

  $('div[id^="opportunity"]', '#opportunities_by_status').each ->
    $(this).draggable
      cursor: 'move',
      revert: (dropped) ->
        if dropped

        else
          $(".opportunity_statuses"). each ->
            $dropP = $(this).find("p")
            setTimeout ->
              $dropP.fadeOut()
            , 3000
          true

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

  $('.opportunity_statuses').on 'click', 'a', ->
    status.select($(this).data("status"), $(this).data("locationid"))
    alert $(this).data("locationid")
status=
  select: (status, location_id) ->
    $.ajax
      type: 'GET'
      url: "/opportunities/by_status"
      data: { status: status, location_id: location_id }

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