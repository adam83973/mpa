jQuery ->
  ignoreDrag = (e) ->
    e.originalEvent.stopPropagation()
    e.originalEvent.preventDefault()

  onDrop = (e) ->
    e.preventDefault()

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