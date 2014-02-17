jQuery ->
  ignoreDrag = (e) ->
    e.originalEvent.stopPropagation()
    e.originalEvent.preventDefault()

  onDrop = (e) ->
    e.preventDefault()

  # $(".leads")
  #   .bind('dragenter', ignoreDrag)
  #   .bind('dragover', ignoreDrag)
  #   .bind('drop', onDrop)

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

  $('.dropdown-menu', '#lead_stages').on 'click', 'a', ->
    stage.select($(this).data("stageid"))

stage=
  select: (stage_id) ->
    $.ajax
      type: 'GET'
      url: "/leads/stage_list"
      data: {stage_id: stage_id}

drop =
  #ajax call to update lead stage
  update: (dragged_id, received_id) ->
    $.ajax
      type: 'POST'
      url: "/leads/update_stage"
      data: { id: received_id, stage: dragged_id }
      success: (result) ->